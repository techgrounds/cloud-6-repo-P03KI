import csv
import os

csvColumn = ['Naam', 'Achternaam', 'Functie', 'Bedrijf']
header = False
myDict = {
    "Naam" : input("Wat is jouw voornaam?\n"),
    "Achternaam" : input("Wat is jouw achternaam?\n"),
    "Functie" : input("Welke functie voer jij uit?\n"),
    "Bedrijf" : input("Bij welk bedrijf ben jij werkzaam?\n")
}

try:
    with open("test.csv", 'a') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=csvColumn)
        if os.path.getsize("test.csv") == 0:
            writer.writeheader()
        writer.writerow(myDict)
        
except IOError:
    print("I/O error")