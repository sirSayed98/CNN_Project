# Python program to convert float
# decimal to binary number

# Function returns octal representation
def float_bin(number, places=3):

    # split() seperates whole number and decimal
    # part and stores it in two seperate variables
    whole, dec = str(number).split(".")

    # Convert both whole number and decimal
    # part from string type to integer type
    whole = int(whole)
    dec = int(dec)

    # Convert the whole number part to it's
    # respective binary form and remove the
    # "0b" from it.
    res = bin(whole).lstrip("0b") + "."

    # Iterate the number of times, we want
    # the number of decimal places to be
    for x in range(places):

        # Multiply the decimal value by 2
        # and seperate the whole number part
        # and decimal part
        whole, dec = str((decimal_converter(dec)) * 2).split(".")

        # Convert the decimal part
        # to integer again
        dec = int(dec)

        # Keep adding the integer parts
        # receive to the result variable
        res += whole

    return res


# Function converts the value passed as
# parameter to it's decimal representation
def decimal_converter(num):
    while num > 1:
        num /= 10
    return num

# Driver Code


def convert_to_decimal(number, precession=11):
    float_part = number - int(number)
    int_part = int(number)

    float_part_str = ""

    zero = float("."+"0" * precession + "1")
    i = 1
    while i <= 11:
        if float_part - (1/(2**i)) >= 0:
            float_part = float_part - (1/2**i)
            float_part_str += "1"
        else:
            float_part_str += "0"

        i += 1
    return bin(int_part)[2:] + "." + float_part_str
# if float_part - 1/(2**i) > 0:
#             float_part = float_part - (1/2**i)
# 			float_part_str += "1"
# 		else:
# 			float_part_str += "0"
#         i += 1
#     return bin(int_part)[2:]


# Take the user input for
# the floating point number
for n in [1.234, 8.2775, 3.55, 16.875]:
    # n = 3.5

    # Take user input for the number of
    # decimal places user want result as
    p = 11

    print(n, convert_to_decimal(n, p))
# print(float_bin(n, places=p))
