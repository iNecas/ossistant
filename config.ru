$:.unshift("#{File.expand_path('..', __FILE__)}/lib")

ENV['RACK_ENV'] ||= 'development'
OSSISTANT_ENV = ENV['RACK_ENV']

require 'ossistant'

Ossistant.setup_env

run Ossistant::Web

class DynflowConsole < Sinatra::Base

  def self.setup(&block)
    Sinatra.new(self) do
      instance_exec(&block)
    end
  end

  dir = File.expand_path('../web', __FILE__)

  set :public_folder, File.join(dir, 'assets')
  set :views, File.join(dir, 'views')

  helpers ERB::Util

  helpers do
    def bus
      settings.bus
    end
  end

  get('/') do
    @plans = bus.persisted_plans
    erb :index
  end

  get('/:persisted_plan_id') do |id|
    @plan = bus.persisted_plan(id)
    @notice = params[:notice]
    erb :show
  end

  post('/:persisted_plan_id/resume') do |id|
    @plan = bus.persisted_plan(id)
    bus.resume(@plan)
    redirect(url "/#{id}?notice=#{url_encode('The action was resumed')}")
  end

  post('/:persisted_plan_id/steps/:persisted_step_id/skip') do |id, step_id|
    @step = bus.persisted_step(step_id)
    bus.skip(@step)
    @plan = bus.persisted_plan(id)
    bus.resume(@plan)
    redirect(url "/#{id}?notice=#{url_encode('The step was skipped and the action was resumed')}")
  end

end

console = DynflowConsole.setup do
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == 'admin' and password == 'admin'
  end

  set :bus, Ossistant.bus
end

map('/dynflow') { run(console) }
