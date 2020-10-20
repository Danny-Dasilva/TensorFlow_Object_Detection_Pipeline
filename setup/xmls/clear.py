import os
import shutil


for f in os.listdir():
    file_name, file_ext = os.path.splitext(f)
    if file_ext == ".jpg":
        os.remove(f)
    if file_ext == ".xml":
        os.remove(f)

