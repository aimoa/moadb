require 'rest-client'

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
        sendTextMessage(sender, text)
      end
    end
    render text: "Hello World."
  end

  private
    def sendTextMessage(sender, text)
      data = {
        'recipient':{'id':sender},
        'message': {'text':text},
      }
      token = "EAAQg2xCDnjoBAGf4ezOpcmmCwAJCOkGZCaCvSog822oeZCLeReOBOZCZAp5CcLJ5fomQFimo1MeLxaezY6cnSiPZCsOMDaBZAI5utX5dYSiFOur5nILgljqWKcpZBGvJi8U7h4ZCij9nZAHRJyUNGBvQiDq2ThqvNZCMC1Y6ta5HZBBZAAZDZD"
      url = 'https://graph.facebook.com/v2.6/me/messages?access_token='+token
      RestClient.post url, data.to_json, 'content_type': :json, 'accept': :json
    end
end
