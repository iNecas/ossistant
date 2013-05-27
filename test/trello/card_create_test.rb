require 'test_helper'
require 'ostruct'

module Ossistant
  module Trello

    describe CardCreate do

      include Dynflow::Test::Unit

      let(:interface) { Ossistant.config.interfaces.find('trello') }
      let(:data) do
        { 'interface'=>{'name'=>'trello'},
          'list_id'=>'1234567',
          'identifier'=>'PR trellolo/123',
          'title'=>'No license',
          'body'=><<BODY }
Open source code without license is as useful as
proprietary code without money.
BODY
      end
      let(:mocked_trello_api) do
        stub = self.stub
        interface.stubs(:api).returns(stub)
        stub
      end

      it 'creates the ticket in Trello' do
        #mocked_trello_api.expects('user').with('iNecas').returns(author_data)
        # TODO: finish after making it work agains the life server
        #action = CardCreate.new(data)
        #action.run
      end
    end
  end
end
