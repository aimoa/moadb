import requests
import tempfile
import math
import numpy as np
import cv2

def ghash(url):
    tmp = tempfile.NamedTemporaryFile()
    tmp.file.write(requests.get(url).content)
    img = cv2.imread(tmp.name,0)/255.
    new_size = 1 << int(math.log(min(img.shape),2))
    img = cv2.resize(img, (new_size,new_size))
    while (len(img) > 8):
        img = cv2.pyrDown(img)
    img = np.gradient(img)
    img = np.concatenate(( \
            img[0][1,2:-2].ravel(), \
            img[0][2:-2,1:-1].ravel(), \
            img[0][-2,2:-2].ravel(), \
            img[1][1,2:-2].ravel(), \
            img[1][2:-2,1:-1].ravel(), \
            img[1][-2,2:-2].ravel()))
    code = 0
    for bit in (img > 0):
        code = (code << 1) | bit
    return hex(code)
