from PIL import Image
import cv2
import numpy as np

import json

shape = {
                "x1": 0.22264296756123736,
                "x2": 0.3375516699080045,
                "y1": 0.6431981754078782,
                "y2": 0.8368961208425227
            }

img = 'render-999y.png'

image = cv2.imread(img)
height, width, channels = image.shape
print(height, width)
img = image

x1 = 196
x2 = 225

y1 = 181
y2 = 152
cv2.rectangle(img,(int(x1),int(y1)),(int(x2),int(y2)),(0,0,255),1)

cv2.imshow('image',img)
cv2.waitKey(0)
