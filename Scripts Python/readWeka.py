import arff
data = arff.load('C:\\Users\\yesika\\Desktop\\Arffs\\wekaP.arff')
a = list(data)
for Row in data:
    print (Row.m1)
        

