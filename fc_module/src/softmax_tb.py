WORD_SIZE = 16
LAYER_SIZE = 10
TEST_CASES_NUM = 10

from tqdm import tqdm
import random
from math import *
import numpy as np

def decimalToBinary(decimalNumber, nBits):
    s = "{0:0"+str(nBits)+"b}"
    sbin = s.format(np.abs(decimalNumber))
    if decimalNumber < 0:
        return twosComplment(sbin)
    return sbin

def twosComplment(binString):
    #print(binString)
    inverted = ''.join('1' if x == '0' else '0' for x in binString)
    sm = "{0:0"+str(WORD_SIZE)+"b}"
    return sm.format(int(inverted,2)+1)

'''def fillWithZeros(s, nBits):
    sf = ''
    if len(s) < nBits:
        sf = '0'*(nBits-len(s))
    return sf + s'''
        
'''def arrToBinary(arr, wordSize=WORD_SIZE):
    myDecimalToBinary = lambda decimalNumber :decimalToBinary(decimalNumber, wordSize)
    myDecimalToBinaryVectorized = np.vectorize(myDecimalToBinary)
    return myDecimalToBinaryVectorized(arr)'''

intRange = 2**(WORD_SIZE-1)

s = ""
for k in tqdm(range(TEST_CASES_NUM)):
    '''all_r = []
    for a in range(LAYER_SIZE):
        r = random.randrange(0,2**WORD_SIZE-1)
        all_r.append(r)
        rb = decimalToBinary(r)
        s += fillWithZeros(rb, WORD_SIZE)'''
    case = ''
    all_r = np.random.randint(low=-intRange, high=intRange, size=(LAYER_SIZE))
    for l in range(len(all_r)):
        case += decimalToBinary(all_r[l], WORD_SIZE) + '_'
    case += '_'
    max_index = LAYER_SIZE-1 - np.argmax(all_r)
    print(all_r, max_index)
    max_index_bin = decimalToBinary(max_index, ceil(log2(LAYER_SIZE)))
    case += max_index_bin
    print(case)
    
    #s += fillWithZeros(max_index_bin, ceil(log2(LAYER_SIZE)))
    s += case + '\n'

f = open("generated_cases_softmax_rand.tv", "w")
f.write(s)
f.close()
