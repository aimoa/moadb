require 'rest-client'

class PagesController < ApplicationController
  def privacy
    render text: 'I will use your Facebook ID to send messages to you.'
  end

  def webhook
    messaging_events = params['entry'][0]['messaging']
    messaging_events.each do |event|
      sender = event['sender']['id']
      if message = event['message']
        if message['text']
          sendGenericMessage(sender)
        elsif message['sticker_id']
          image = Image.order(:created_at).last
          sendPersonalMessage(sender, 'here is the image most recently added to my database.')
          sendImageMessage(sender, image.url)
          sendTextMessage(sender, image_url(image))
        else
          sendImageMessage(sender, 'https://scontent-sjc2-1.xx.fbcdn.net/hphotos-xfl1/v/l/t1.0-9/1936170_706844699418785_795891061800435628_n.jpg?oh=82e737f06b6c77fdf7543af2ac13f80f&oe=577C8315')
          sendPersonalMessage(sender, 'spaghetti~')
        end
      end
    end
    render text: 'Hello World.'
  end

  private
    def sendMessage(recipient, messageData)
      data = {
        :recipient => {
          :id => recipient
        },
        :message => messageData
      }
      token = 'EAAQg2xCDnjoBAGf4ezOpcmmCwAJCOkGZCaCvSog822oeZCLeReOBOZCZAp5CcLJ5fomQFimo1MeLxaezY6cnSiPZCsOMDaBZAI5utX5dYSiFOur5nILgljqWKcpZBGvJi8U7h4ZCij9nZAHRJyUNGBvQiDq2ThqvNZCMC1Y6ta5HZBBZAAZDZD'
      url = 'https://graph.facebook.com/v2.6/me/messages?access_token='+token
      RestClient.post url, data.to_json, :content_type => 'application/json', :accept => 'application/json'
    end

    def sendTextMessage(recipient, text)
      messageData = {
        :text => text
      }
      sendMessage(recipient, messageData)
    end

    def sendPersonalMessage(recipient, text)
      token = 'EAAQg2xCDnjoBAGf4ezOpcmmCwAJCOkGZCaCvSog822oeZCLeReOBOZCZAp5CcLJ5fomQFimo1MeLxaezY6cnSiPZCsOMDaBZAI5utX5dYSiFOur5nILgljqWKcpZBGvJi8U7h4ZCij9nZAHRJyUNGBvQiDq2ThqvNZCMC1Y6ta5HZBBZAAZDZD'
      url = "https://graph.facebook.com/v2.6/#{recipient}?fields=first_name,last_name,profile_pic&access_token="+token
      response = JSON.parse(RestClient.get url)
      text = response['last_name']+'さん, '+text
      sendTextMessage(recipient, text)
    end

    def sendImageMessage(recipient, url)
      messageData = {
        :attachment => {
          :type => 'image',
          :payload => {
            :url => url
          }
        }
      }
      sendMessage(recipient, messageData)
    end

    def sendGenericMessage(recipient)
      messageData = {
        :attachment => {
          :type => 'template',
          :payload => {
            :template_type => 'generic',
            :elements => [
              {
                :title => 'Saisho',
                :image_url => Image.first.url,
                :subtitle => 'First image in my database.',
                :buttons => [
                  {
                    :type => 'web_url',
                    :url => image_url(Image.first),
                    :title => 'View Page'
                  },
                  {
                    :type => 'postback',
                    :title => 'Postback',
                    :payload => 'Payload for first element in a generic bubble'
                  }
                ]
              },
              {
                :title => 'Saigo',
                :image_url => Image.last.url,
                :subtitle => 'Last image in my database.',
                :buttons => [
                  {
                    :type => 'web_url',
                    :url => image_url(Image.last),
                    :title => 'View Page'
                  },
                  {
                    :type => 'postback',
                    :title => 'Postback',
                    :payload => 'Payload for second element in a generic bubble'
                  }
                ]
              }
            ]
          }
        }
      }
      sendMessage(recipient, messageData)
    end
end
