require 'telegram/bot'
TELEGRAM_BOT_TOKEN = '221621473:AAECLZh4VDZ19LVBLskZiaf4rw4Emnj-6vE'
API_URL = 'https://api.telegram.org'

class HomeController < ApplicationController
  def index

  end

  def webhook_request
    a = 2
  end

  def set_webhook
    params = {url: 'https://192.168.1.37:8443/webhook_request'}
    endpoint = '/setWebhook'
    response = conn.post("/bot#{TELEGRAM_BOT_TOKEN}/#{endpoint}", params)
    if response.status == 200
      @data = JSON.parse(response.body)
    else
      @error = JSON.parse(response.body)
    end
  end


  def get_to_api
    params = {}
    endpoint = '/getUpdates'
    response = conn.post("/bot#{TELEGRAM_BOT_TOKEN}/#{endpoint}", params)
    if response.status == 200
      @data = JSON.parse(response.body)
    else
      @error = JSON.parse(response.body)
    end
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

  def conn
    @conn ||= Faraday.new(url: API_URL) do |faraday|
      faraday.request :multipart
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end

end
