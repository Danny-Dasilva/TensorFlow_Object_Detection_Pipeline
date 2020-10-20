import os
import glob
import pandas as pd
import xml.etree.ElementTree as ET


def xml_to_csv(path):
    xml_list = []
    for xml_file in glob.glob(path + '/*.xml'):
        print(xml_file, path + '/*.xml')
        tree = ET.parse(xml_file)
        root = tree.getroot()
        for member in root.findall('object'):
            value = (root.find('filename').text,
                     int(root.find('size')[0].text),
                     int(root.find('size')[1].text),
                     member[0].text,
                     int(member[4][0].text),
                     int(member[4][1].text),
                     int(member[4][2].text),
                     int(member[4][3].text)
                     )
            xml_list.append(value)
    column_name = ['filename', 'width', 'height', 'class', 'xmin', 'ymin', 'xmax', 'ymax']
    df = pd.DataFrame(xml_list, columns=column_name)
    for index, row in df.iterrows():
        xmin = row['xmin']
        xmax = row['xmax']
        ymin = row['ymin']
        ymax = row['ymax']
        filename = row['filename']
        print(row['class'], "filename")
        if xmin > xmax:
            df.loc[index, 'xmin'] = xmax
            df.loc[index, 'xmax'] = xmin

        if ymin > ymax:
            df.loc[index, 'ymin'] = ymax
            df.loc[index, 'ymax'] = ymin

        else:
            pass
   
    return df


def main():
    for folder in ['train','test']:
        image_path = os.path.join(os.getcwd(), ('images/' + folder))
        print('images/' + folder)
        xml_df = xml_to_csv(image_path)
        for index, row in xml_df.iterrows():
            xmin = row['xmin']
            xmax = row['xmax']
            ymin = row['ymin']
            ymax = row['ymax']
            if xmin > xmax:
                print("err")
            if ymin > ymax:
                print("err")
            else:
                pass

        xml_df.to_csv(('images/' + folder + '_labels.csv'), index=None)
        print('Successfully converted xml to csv.')


main()
