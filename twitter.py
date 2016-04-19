import requests
import json
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream

from config import *
from ghash import ghash

class MoaListener(StreamListener):
    def on_data(self, data):
        data = json.loads(data)
        if "extended_entities" in data:
            entities = data["extended_entities"]
            if "media" in entities:
                for medium in entities["media"]:
                    if medium["type"]=="video":
                        continue
                    print medium["media_url"]
                    url = medium["media_url_https"]
                    tweet = medium["url"]
                    code = ghash(url)
                    data = json.dumps({'image': { \
                            'url': url, \
                            'tweet': tweet, \
                            'ghash': code \
                            }})
                    headers = {'content-type': 'application/json'}
                    r = requests.post(server, data=data, headers=headers)
        return True

    def on_error(self, status):
        print status

def save_img(pk,url):
    f = open('{:09d}.jpg'.format(pk),"wb")
    f.write(requests.get(url).content)
    f.close()

if __name__ == '__main__':
    listener = MoaListener()
    auth = OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)

    stream = Stream(auth, listener)
    stream.filter(track=keywords)
