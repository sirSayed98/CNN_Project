WORD_SIZE = 16
LAYER_SIZE = 10
TEST_CASES_NUM = 10

from tqdm import tqdm
import random
from math import *

def decimalToBinary(n):
    return bin(n).replace("0b", "")

def fillWithZeros(s, nBits):
    sf = ''
    if len(s) < nBits:
        sf = '0'*(nBits-len(s))
    return sf + s
        

s = ""
for k in tqdm(range(TEST_CASES_NUM)):
    all_r = []
    for a in range(LAYER_SIZE):
        r = random.randrange(0,2**WORD_SIZE-1)
        all_r.append(r)
        rb = decimalToBinary(r)
        s += fillWithZeros(rb, WORD_SIZE)
    
    max_index = all_r.index(max(all_r))
    max_index_bin = str(decimalToBinary(max_index))
    s += '_'
    s += fillWithZeros(max_index_bin, ceil(log2(LAYER_SIZE)))
    s += '\n'

f = open("generated_cases_softmax_rand.tv", "w")
f.write(s)
f.close()
