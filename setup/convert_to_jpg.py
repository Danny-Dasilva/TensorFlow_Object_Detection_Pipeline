from PIL import Image
import os


for f in os.listdir():
    file_name, file_ext = os.path.splitext(f)
    if file_ext == ".png":
        #os.remove(f)
        im = Image.open(f)
        rgb_im = im.convert('RGB')
        rgb_im.save(file_name + '.jpg')
        os.remove(f)