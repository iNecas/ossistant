require 'delayed_job_active_record'

module Ossistant
  class DelayedBus

    class DelayedExecutor < Struct.new(:action_class, :args)

      def perform
        Ossistant.persisted_bus.trigger(action_class, *args)
      end

    end

    def trigger(action_class, *args)
      Delayed::Job.enqueue(DelayedExecutor.new(action_class, args))
    end

  end
end
