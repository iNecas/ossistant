require 'trello'

module Ossistant
  module Interfaces

    class Trello < Interfaces::Base
      attr_reader :key, :secret, :token

      def self.type_name
        'trello'
      end

      def initialize(config)
        super
        @key = config['key']
        @secret = config['secret']
        @token = config['token']
      end

      def api
        @api ||= Api.new(self)
      end

      class Api
        # @param [Interfaces::Trello] api
        def initialize(interface)
          @client = ::Trello::Client.new(:consumer_key => interface.key,
                                         :consumer_secret => interface.secret,
                                         :oauth_token => interface.token)
        end

        def find_card(list_id, identifier)
          list = @client.find(:list, list_id)
          all_cards = list.board.cards
          if card = all_cards.find { |card| card.name.include? identifier }
            return card
          end
        end

        def create_card(list_id, identifier, title, body)
          name = "(#{identifier}) #{title}"

          @client.create(:card,
                         'idList' => list_id,
                         'name' => name,
                         'desc' => body)
        end

        def archive_card(card)
          card.add_comment('Pull request closed. Archiving')
          card.closed = true
          card.save
        end

      end

    end
  end
end

