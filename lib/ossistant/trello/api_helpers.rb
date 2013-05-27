module Ossistant
  module Trello
    class ApiHelpers

      # @param [Trello::Client] api
      def initialize(api)
        @api = api
      end

      def find_card(list_id, identifier)
        list = @api.find(:list, list_id)
        all_cards = list.board.cards
        if card = all_cards.find { |card| card.name.include? identifier }
          return card
        end
      end

      def create_card(list_id, identifier, title, body)
        name = "(#{identifier}) #{title}"

        @api.create(:card,
                    'idList' => list_id,
                    'name' => name,
                    'desc' => body)
      end

    end
  end
end
