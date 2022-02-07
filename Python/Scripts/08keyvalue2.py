#import
import csv
csvColumn =  ['Naam', 'Achternaam', 'Functie', 'Bedrijf']

#vragen
myDict = {}
myDict["Naam"] = input("Wat is jouw voornaam?")
myDict["Achternaam"] = input("Wat is jouw achternaam?")
myDict["Functie"] = input("Welke functie voer jij uit?")
myDict["Bedrijf"] = input("Bij welk bedrijf ben jij werkzaam?")
print(myDict)

csv_file = "test.csv"
try:
    with open(csv_file, 'w') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=csvColumn)
        writer.writeheader()
        for data in myDict:
            writer.writerow(data)
except IOError:
    print("I/O error")