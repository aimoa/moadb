require 'rest-client'

class PagesController < ApplicationController
  def privacy
    render text: 'I will sometimes use your Facebook name to send messages to you.'
  end

  def webhook
    messaging_events = params['entry'][0]['messaging']
    messaging_events.each do |event|
      sender = event['sender']['id']
      if message = event['message']
        if message['text']
          text = message['text'].split
          if text.length < 2
            sendPersonalMessage(sender, 'I want to make you smile! Try sending me a thumbs up!')
            render text: '' and return
          end
          case text[0].downcase
          when 'delete'
            sendDeleteMessage(sender, text[1])
          else
            sendPersonalMessage(sender, 'sorry . . . my English is very limited! Please try using my website while I study harder.')
            sendTextMessage(sender, root_url)
          end
        elsif message['sticker_id']
          image = Image.where(:spam => false).order(:created_at).last
          sendPersonalMessage(sender, 'here is the image most recently added to my database.')
          sendImageMessage(sender, image.url)
          sendTextMessage(sender, image_url(image))
        else
          sendImageMessage(sender, 'https://scontent-sjc2-1.xx.fbcdn.net/hphotos-xfl1/v/l/t1.0-9/1936170_706844699418785_795891061800435628_n.jpg?oh=82e737f06b6c77fdf7543af2ac13f80f&oe=577C8315')
          sendPersonalMessage(sender, 'spaghetti~')
        end
      elsif postback = event['postback']
        payload = event['postback']['payload'].split
        if payload[0..-2].join(' ') == payload_prefix('delete')
          @image = Image.find(payload[-1])
          @image.update(:spam => true)
          sendPersonalMessage(sender, "I just deleted #{payload[-1]} for you~")
        end
      end
    end
    render text: ''
  end

  private
    def sendMessage(recipient, messageData)
      data = {
        :recipient => {
          :id => recipient
        },
        :message => messageData
      }
      url = 'https://graph.facebook.com/v2.6/me/messages?access_token='+access_token()
      RestClient.post url, data.to_json, :content_type => 'application/json', :accept => 'application/json'
    end

    def sendTextMessage(recipient, text)
      messageData = {
        :text => text
      }
      sendMessage(recipient, messageData)
    end

    def sendPersonalMessage(recipient, text)
      url = "https://graph.facebook.com/v2.6/#{recipient}?fields=first_name,last_name,profile_pic&access_token="+access_token()
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

    def sendDeleteMessage(recipient, ghash)
      begin
        @image = Image.find(ghash)
      rescue ActiveRecord::RecordNotFound
        sendPersonalMessage(recipient, 'sumimasen. I couldn\'t find that record!')
        return
      end
      messageData = {
        :attachment => {
          :type => 'template',
          :payload => {
            :template_type => 'generic',
            :elements => [
              {
                :title => @image.ghash,
                :image_url => @image.url,
                :subtitle => 'Are you sure you want to delete this image? This action cannot be undone.',
                :buttons => [
                  {
                    :type => 'web_url',
                    :url => @image.url,
                    :title => 'View'
                  },
                  {
                    :type => 'postback',
                    :title => 'Delete',
                    :payload => payload_prefix('delete') + ' ' + @image.ghash
                  }
                ]
              }
            ]
          }
        }
      }
      sendMessage(recipient, messageData)
    end

    def payload_prefix(postback)
      case postback
      when 'delete'
        return 'Simon says sakujo sakujo sakujo'
      end
    end

    def access_token()
      return 'EAAQg2xCDnjoBAGf4ezOpcmmCwAJCOkGZCaCvSog822oeZCLeReOBOZCZAp5CcLJ5fomQFimo1MeLxaezY6cnSiPZCsOMDaBZAI5utX5dYSiFOur5nILgljqWKcpZBGvJi8U7h4ZCij9nZAHRJyUNGBvQiDq2ThqvNZCMC1Y6ta5HZBBZAAZDZD'
    end
end
