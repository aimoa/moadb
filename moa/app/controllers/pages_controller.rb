require "uri"
require "net/http"

class PagesController < ApplicationController
  def privacy
    render text: "I will use your Facebook ID to send messages to you."
  end

  def webhook
    messaging_events = params["entry"][0]["messaging"]
    messaging_events.each do |event|
      sender = event["sender"]["id"]
      if (event["message"] && event["message"]["text"])
        text = event["message"]["text"]
      end
    end
    render text: "Hello World."
  end

  private
    def sendTextMessage(sender, text)
      token = "EAAQg2xCDnjoBAGf4ezOpcmmCwAJCOkGZCaCvSog822oeZCLeReOBOZCZAp5CcLJ5fomQFimo1MeLxaezY6cnSiPZCsOMDaBZAI5utX5dYSiFOur5nILgljqWKcpZBGvJi8U7h4ZCij9nZAHRJyUNGBvQiDq2ThqvNZCMC1Y6ta5HZBBZAAZDZD"
end
