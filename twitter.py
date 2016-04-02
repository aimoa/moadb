# -*- coding: utf-8 -*-

import requests
import json
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream

from config import *

class MoaListener(StreamListener):
    def on_data(self, data):
        data = json.loads(data)
        if "extended_entities" in data:
            entities = data["extended_entities"]
            if "media" in entities:
                for medium in entities["media"]:
                    url = medium["media_url_https"]+":large"
                    print url
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
    stream.filter(track=['kikuchi moa','moa metal',u'菊地最愛'])
