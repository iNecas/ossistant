require 'test_helper'

module Ossistant

  describe Interfaces do

    subject do
      Ossistant.config.interfaces
    end

    it 'preloads the interfaces from configuration' do
      github = subject.find('github')
      github.class.must_equal Ossistant::Interfaces::Github
      github.name.must_equal 'github'
      github.secret.must_equal 'github_secret'
    end

  end

end
