import sys
import requests
import math
import cv2
import numpy as np
from skimage import io

def ghash(url):
    img = io.imread(url)[...,:3]
    img = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)/255.
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
    return '{:016x}'.format(int(code) & (2**64-1))

if __name__ == "__main__":
    sys.stdout.write(ghash(sys.argv[1]))
