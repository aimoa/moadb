import requests
import json
from tweepy import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream

from config import *
from ghash import ghash

class ImageListener(StreamListener):
    self.subject = 0
    def on_data(self, data):
        data = json.loads(data)
        if "extended_entities" in data and "media" in data["extended_entities"]:
            for medium in data["extended_entities"]["media"]:
                if medium["type"]=="video":
                    continue
                url = medium["media_url_https"]
                tweet = medium["url"]
                code = ghash(url)
                data = json.dumps({'image': { \
                        'url': url, \
                        'tweet': tweet, \
                        'ghash': code \
                        'subject': self.subject
                        }})
                headers = {'content-type': 'application/json'}
                r = requests.post(server, data=data, headers=headers)
        return True

    def on_error(self, status):
        print status

class MoaListener(ImageListener):
    self.subject = subjects['Moa']

class SuListener(ImageListener):
    self.subject = subjects['Su']

class YuiListener(ImageListener):
    self.subject = subjects['Yui']

if __name__ == '__main__':
    listener = MoaListener()
    auth = OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)

    stream = Stream(auth, listener)
    stream.filter(track=keywords)
