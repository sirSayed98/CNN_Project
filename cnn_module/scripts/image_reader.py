from skimage import io
img_in_file = "00001.bmp"
img_out_file = img_in_file[:img_in_file.find(".")] + ".binary"
img = io.imread(img_in_file)

width = 32
lines = []
for row in img:
    for pixel in row:
        # print(pixel)
        out = bin(pixel)
        out = out[2:]
        out = '0' * (width - len(out)) + out
        # print(out)
        lines.append(out)
file_out = open(img_out_file, 'w')
for i, line in enumerate(lines):
    file_out.write(line + ("\n" if i != len(lines) - 1 else ""))
file_out.close()
# Python program to convert float
# decimal to binary number

# Function returns octal representation
def float_bin(number, places = 3):

	# split() seperates whole number and decimal
	# part and stores it in two seperate variables
	whole, dec = str(number).split(".")

	# Convert both whole number and decimal
	# part from string type to integer type
	whole = int(whole)
	dec = int (dec)

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
