require 'test_helper'

module Ossistant

  describe Interfaces do

    subject do
      Ossistant.config.interfaces
    end

    it 'preloads the interfaces from configuration' do
      github = subject.find('github')
      github.class.must_equal Ossistant::Github::PushInterface
      github.name.must_equal 'github'
      github.token.must_equal 'github_token'
    end

  end

end
