import numpy as np
from skimage.io import  imread
from skimage.transform import resize
import sys
  
print(sys.argv[1])
print(sys.argv[2])



image_file = sys.argv[1]
out_file   = sys.argv[2]
img = imread(image_file)


#add padding
original=img
seSize = 2
start=1

newH = img.shape[1]+ 2 * seSize
newW = img.shape[0]+ 2 * seSize
img = np.zeros((newW, newH))
img[start:start+original.shape[0], start:start+original.shape[1]] = original



pixels = []
for row in img:
    for pixel in row:
        pixels.append(str(pixel/255))


       
file1 = open(out_file ,"w")
for i in pixels:
    file1.write(f'{i}\n')

file1.close()