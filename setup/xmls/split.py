import os
import random
import xml.etree.ElementTree as ET
path = os.getcwd()
images = []
for filename in os.listdir(path):
    if filename.endswith('.jpg'):
        images.append(filename)
    random.shuffle(images)
    sizeOfArray=len(images)
    trainArray=images[:int(len(images)*0.8)]
    testArray=images[int(len(images)*0.8):]
print(len(trainArray))
print(len(testArray))
for train in trainArray:
    print(path+"/"+train)
    tree = ET.parse(train.split(".")[0]+".xml")
    root = tree.getroot()
    root[0].text = "train"
    tree.write(train.split(".")[0]+".xml")
    os.rename(path+"/"+train, path+"/Images/Train/"+train)
    os.rename(path+"/"+train.split(".")[0]+".xml", path+"/Images/train/"+train.split(".")[0]+".xml")
for test in testArray:
    tree = ET.parse(test.split(".")[0]+".xml")
    root = tree.getroot()
    root[0].text = "test"
    tree.write(test.split(".")[0]+".xml")
    os.rename(path+"/"+test, path+"/Images/Test/"+test)
    os.rename(path+"/"+test.split(".")[0]+".xml", path+"/Images/test/"+test.split(".")[0]+".xml")
