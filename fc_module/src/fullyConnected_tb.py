TEST_CASES_NUM = 10

WORD_SIZE = 16
IN_LAYER_SIZE = 10
OUT_LAYER_SIZE = 5

from os import W_OK
from tqdm import tqdm
import random
from math import *
import numpy as np

def decimalToBinary(decimalNumber, nBits):
    s = "{0:0"+str(nBits)+"b}"
    return s.format(decimalNumber)

def decimalToBinaryWithClipping(decimalNumber, nBits, fromIndexInclusive, toIndexInclusive):
    notClipped = decimalToBinary(decimalNumber, nBits)
    return notClipped[fromIndexInclusive:toIndexInclusive+1]

def concatArray(arr):
    return " ".join(list(arr))

def concatArrayNoSpace(arr):
    return "".join(list(arr))

def arrToBinary(arr, wordSize=WORD_SIZE):
    myDecimalToBinary = lambda decimalNumber :decimalToBinary(decimalNumber, wordSize)
    myDecimalToBinaryVectorized= np.vectorize(myDecimalToBinary)
    return myDecimalToBinaryVectorized(arr)

def arrToBinaryWithClipping(arr, wordSize, fromIndexInclusive, toIndexInclusive):
    myDecimalToBinary = lambda decimalNumber :decimalToBinaryWithClipping(decimalNumber, wordSize, fromIndexInclusive, toIndexInclusive)
    myDecimalToBinaryVectorized= np.vectorize(myDecimalToBinary)
    return myDecimalToBinaryVectorized(arr)

def xorBinBit(bit0, bit1):
    return bool(int(bit0)) ^ bool(int(bit1))

#C:\Users\Yamani\Desktop\College\VLSI\CNN_Project\fc_module\src>C:/Users/Yamani/anaconda3/python.exe c:/Users/Yamani
#/Desktop/College/VLSI/CNN_Project/fc_module/src/fullyConnected_tb.py

#[2  :5]
#[4-2:4+2-1]
#10011000
#  0110
#print(bool(int('0')), bool(int('1')))
print(xorBinBit('0', '0'))
print(xorBinBit('0', '1'))
print(xorBinBit('1', '0'))
print(xorBinBit('1', '1'))


'''
X = np.random.randint(2**(WORD_SIZE*2-1), size=(5))
#01111110000001111010001110101101
#        0000011110100011
print(arrToBinary(X))
print(arrToBinaryWithClipping(X, WORD_SIZE*2, int(WORD_SIZE-WORD_SIZE/2), int(WORD_SIZE+WORD_SIZE/2)-1))
print(concatArray(arrToBinaryWithClipping(X.flatten(), int(WORD_SIZE-WORD_SIZE/2), int(WORD_SIZE+WORD_SIZE/2)-1, WORD_SIZE*2)))'''


getlength = lambda x : len(x)

getlengthVectorized = np.vectorize(getlength)


def twosComplment(binString,size):
    print(binString)
    inverted = ''.join('1' if x == '0' else '0' for x in binString)
    sm = "{0:0"+str(size)+"b}"
    return sm.format(int(inverted,2)+1)[-size:]





def clipDecimalWithSign(num, originalSize):
    #print(num)
    myS = "{0:0"+str(originalSize)+"b}"
    myBin = myS.format(num)
    #print(myBin)
    negative= False
    if(myBin[0] == '1'):
        negative = True
        myBin = twosComplment(myBin,32)
    
    #print(myBin)

    myBinClipped = myBin[8:24]
    if (negative):
        myBinClipped = twosComplment(myBinClipped,16)

    #print(myBin)
    #print(myBinClipped)
    #print(int(myBinClipped,2))
    #print("-"*20)
    return int(myBinClipped,2)




    
def clipDecimal2(num, originalSize):
    myS = "{0:0"+str(originalSize)+"b}"
    myBin = myS.format(num)[16:]
    #print(num)
    #print(myBin)
    #print(int(myBin,2))
    #print("-"*20)
    return int(myBin,2)

clipDecimalWithSign(69, WORD_SIZE*2)


sX = ""
sW = ""
sB = ""
sZ = ""
intRange = 500 
for i in tqdm(range(TEST_CASES_NUM)):
    #X
    X = np.random.randint(intRange, size=(IN_LAYER_SIZE))

    #W
    W = np.random.randint(intRange, size=(OUT_LAYER_SIZE, IN_LAYER_SIZE))

    #B
    B = np.random.randint(intRange, size=(OUT_LAYER_SIZE))

    #Z
    """
    intrmd = np.matmul(W,X)
    intrmdBin1D = arrToBinaryWithClipping(intrmd.flatten(), WORD_SIZE*2, int(WORD_SIZE-WORD_SIZE/2), int(WORD_SIZE+WORD_SIZE/2)-1)
    intrmdBin2D = intrmdBin1D.reshape((OUT_LAYER_SIZE, IN_LAYER_SIZE))
    """
    #Z = intrmd + B
    #Z = np.matmul(W,X)
    Z = np.zeros((OUT_LAYER_SIZE))
    #intrmd = np.zeros((OUT_LAYER_SIZE-1, IN_LAYER_SIZE))
    #prod = np.zeros((OUT_LAYER_SIZE, IN_LAYER_SIZE)) #Why -1?

    for i in range (OUT_LAYER_SIZE):
        Z[i] = 0
        for j in range (IN_LAYER_SIZE):
            """
            intrmd[i][j] = X[j] * W[i][j]
            prod[i][j] = clipDecimal(intrmd[i][j], WORD_SIZE*2)
            
            signBitX = decimalToBinary(X[j])[0]
            signBitW = decimalToBinary(W[i][j])[0]
            if xorBinBit(signBitX, signBitW) == xorBinBit(prod[i][j][0]): #Verify sign bit
                prod[i][j] = twosComplment(prod[i][j])
            """
            prod = X[j] * W[i][j]
            prod = clipDecimalWithSign(int(prod) , WORD_SIZE*2)
            
            Z[i] += prod
            
        
        Z[i] = Z[i] + B[i]
        Z[i] = clipDecimal2(int(Z[i]), WORD_SIZE*2)
    

    sX += concatArray(arrToBinary(X, WORD_SIZE)) + '\n'
    #print(np.max(getlengthVectorized(arrToBinary(X))))
    sW += concatArray(arrToBinary(W.flatten(), WORD_SIZE)) + '\n'
    #print(np.max(getlengthVectorized(arrToBinary(W.flatten()))))
    sB += concatArray(arrToBinary(B, WORD_SIZE)) + '\n'
    #print(np.max(getlengthVectorized(arrToBinary(B))))
    #s += '_' 
    #
    #
    sZ += concatArray(arrToBinary(Z.astype(np.int32), WORD_SIZE)) + '\n'
    #sZ += concatArray(arrToBinary(Z, WORD_SIZE*2)) + '\n'
    print(np.max(getlengthVectorized(arrToBinary(Z.astype(np.int32), WORD_SIZE))))
    #print(sX,sW,sB,sZ)
    #s += '\n'
    



#1.1
#1.1
#11.11

# 
# 10010010
#   110101

def write(filePath, s):
    f = open(filePath, "w")
    #f.write(sX + '\n\n\n' + sW + '\n\n\n' + sB + '\n\n\n' + sZ + '\n\n\n')
    f.write(s)
    f.close()


write("generated_cases_fullyconnected_rand_X.tv", sX)
write("generated_cases_fullyconnected_rand_W.tv", sW)
write("generated_cases_fullyconnected_rand_B.tv", sB)
write("generated_cases_fullyconnected_rand_Z.tv", sZ)
