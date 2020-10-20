import os
import shutil

import os
filepath = os.path.dirname(os.path.abspath(__file__))


path = f"{filepath}/"
moveto = f"{filepath}/xmls/"

print(filepath)

for f in os.listdir():
    file_name, file_ext = os.path.splitext(f)
    if file_ext == ".jpg":

        src = path+f
        dst = moveto+f
        shutil.copy(src,dst)

