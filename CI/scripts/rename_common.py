import os
import glob
import pathlib
import shutil

new_dir = "+commonrf"

path = pathlib.Path(__file__).parent.resolve()

path = os.path.split(path)
path = os.path.split(path[0])[0]

files = glob.glob(os.path.join(path, "+adi", "**/*"))
if len(files) == 0:
    print("No files found")
    print("Did you clone all the submodules?")
    exit(1)

for file in files:
    if os.path.isdir(file):
        continue
    with open(file, "r") as f:
        content = f.read()
    if "adi.common." in content:
        content = content.replace("adi.common.", f"adi.{new_dir[1:]}.")
        print("Updating:", file)
        with open(file, "w") as f:
            f.write(content)

src = os.path.join(path, "+adi", "+common")
dst = os.path.join(path, "+adi", new_dir)
if os.path.isdir(src):
    print("Renaming:", src, "->", dst)
    try:
        os.mkdir(dst)
    except OSError as error:
        print(error)
    for file in os.listdir(src):
        print(file)
        shutil.move(os.path.join(src, file), dst)
else:
    print("No +common folder found. Maybe you already renamed it?")
