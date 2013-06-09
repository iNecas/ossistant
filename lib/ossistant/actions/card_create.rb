module Ossistant
  module Actions

    class CardCreate < Dynflow::Action

      input_format do
        param :interface, Hash do
          param :name
        end
        param :card, Hash do
          param :list_id
          param :identifier
          param :title
          param :body
        end
      end

      def run
        card_data = input['card']
        unless api.find_card(card_data['list_id'], card_data['identifier'])
          api.create_card(card_data['list_id'],
                          card_data['identifier'],
                          card_data['title'],
                          card_data['body'])
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
