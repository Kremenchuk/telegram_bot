require 'telegram/bot'
TELEGRAM_BOT_TOKEN = '221621473:AAECLZh4VDZ19LVBLskZiaf4rw4Emnj-6vE'
API = 'https://api.telegram.org/bot'

class HomeController < ApplicationController
  def index

  end

  def get_to_api

  end

  def start_bot
    Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
      bot.listen do |client|
        begin
          case client.text
            when '/start'
              message = 'London is a capital of which country?'
              markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(A B), %w(C D)], one_time_keyboard: true)
            when '/p'
              message = "/setcommands"
              bot.api.send_message(chat_id: '@SergiyNazarov', text: message)
            when 'Привет'
              message = "И тебе привет"
            else
              message = "#{client.from.first_name} ?"
          end
        rescue => e
          bot_send(bot, client, "Error #{e.message}", markup)
        end

        bot_send(bot, client, message, markup)
      end
    end
  end

  def bot_send(bot, client, message, markup)
    bot.api.send_message(chat_id: client.chat.id, text: message, reply_markup:markup)
  end
end
