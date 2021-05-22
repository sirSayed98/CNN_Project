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
# file_out.writelines(lines)
file_out.close()
