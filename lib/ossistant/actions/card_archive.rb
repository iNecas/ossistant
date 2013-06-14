module Ossistant
  module Actions

    class CardArchive < Dynflow::Action

      input_format do
        param :interface, Hash do
          param :name
        end
        param :card, Hash do
          param :list_id
          param :identifier
        end
      end

      def run
        card_data = input['card']
        if card = api.find_card(card_data['list_id'], card_data['identifier'])
          api.archive_card(card)
        end
      end

      def api
        return @api if @api
        interface = Ossistant.config.interfaces.find(input['interface']['name'])
        @api = interface.api
      end

    end
  end
end
