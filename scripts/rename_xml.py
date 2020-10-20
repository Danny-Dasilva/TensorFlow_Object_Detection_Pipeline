import os
import glob
import pandas as pd
import xml.etree.ElementTree as ET


def xml_to_csv(path):
    xml_list = []
    for xml_file in glob.glob(path + '/*.xml'):
        
        tree = ET.parse(xml_file)
        root = tree.getroot()
        value = os.path.basename(xml_file)

        base, ext = os.path.splitext(value)
        print(base, ext)

        for member in root.findall('object'):
            
            elem = root.find('filename')
      
            elem.text = base + ".jpg"
        tree.write(value)
            



xml_to_csv('/home/danny/Desktop/working/xml')