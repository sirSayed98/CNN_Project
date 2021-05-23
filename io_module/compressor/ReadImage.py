from numpy import str0
from skimage.io import  imread
from skimage.transform import resize
import sys
  
print(sys.argv[1])
print(sys.argv[2])

image_file = sys.argv[1]
out_file   = sys.argv[2]

img = imread(image_file)

img=resize(img,(32,32))


pixels = []
for row in img:
    for pixel in row:
        pixels.append(str(pixel))

       
file1 = open(out_file ,"w")
for i in pixels:
    file1.write(f'{i}\n')

file1.close()