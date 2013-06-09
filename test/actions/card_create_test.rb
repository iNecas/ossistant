require 'test_helper'
require 'ostruct'

module Ossistant
  module Actions

    describe CardCreate do

      include Dynflow::Test::Unit

      let(:interface) { Ossistant.config.interfaces.find('trello') }
      let(:data) do
        {
          'interface' => { 'name' => 'trello'},
          'card' => {
            'list_id' => '1234567',
            'identifier' => 'PR trellolo/123',
            'title' => 'No license',
            'body' => <<BODY
Open source code without license is as useful as
proprietary code without money.
BODY
          }
        }
      end
      let(:mocked_trello_api) do
        stub = self.stub
        interface.stubs(:api).returns(stub)
        stub
      end

      it 'creates the ticket in Trello' do
        mocked_trello_api.expects('find_card').with('1234567', 'PR trellolo/123').
          returns(nil)
        mocked_trello_api.expects('create_card')
        action = CardCreate.new(data)
        action.run
      end
    end
  end
end
