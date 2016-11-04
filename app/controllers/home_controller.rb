require 'telegram/bot'
TELEGRAM_BOT_TOKEN = '221621473:AAECLZh4VDZ19LVBLskZiaf4rw4Emnj-6vE'
API = 'https://api.telegram.org/bot'

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
      JSON.parse(response.body)
    else
      raise Exceptions::ResponseError.new(response),
            'Telegram API has returned the error.'
    end
  end


  def get_to_api
    method = '/getUpdates'
    attr = {
        timeout: 10
    }
    begin
      @data = JSON.parse(RestClient.post(API + TELEGRAM_BOT_TOKEN + method, attr.to_json, headers: {:content_type=>"application/json"}))
    rescue => @error
    end
    respond_to do |format|
      format.js {}
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
    @conn ||= Faraday.new(url: 'https://api.telegram.org') do |faraday|
      faraday.request :multipart
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end

end
