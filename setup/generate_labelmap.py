
import os
path = 'images/train_labels.csv'



import csv
col = []

with open(path, newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        #print(set(row['class']))
        col.append(row['class'])


classes = list(set(col))

print("classes:", *classes)
count = 0
with open("training/labelmap.pbtxt","w") as pbtxt_label:
    for label in classes:
        count += 1
        pbtxt_label.write("item {\n") 
        pbtxt_label.write("  id: %s\n" % (count)) 
        pbtxt_label.write("  name: '%s'\n" % (label)) 
        
        pbtxt_label.write("}\n") 
        pbtxt_label.write("\n")
    

with open("training/labels.txt","w") as txt_label:

    for count, label in enumerate(classes):
        txt_label.write("%s %s\n" % (count, label)) 
