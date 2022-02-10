import csv
import os

csvColumn = ['Naam', 'Achternaam', 'Functie', 'Bedrijf']
csv1 = "Python/Scripts/test.csv"
myDict = {
    "Naam" : input("Wat is jouw voornaam?\n"),
    "Achternaam" : input("Wat is jouw achternaam?\n"),
    "Functie" : input("Welke functie voer jij uit?\n"),
    "Bedrijf" : input("Bij welk bedrijf ben jij werkzaam?\n")
}

try:
    with open(csv1, 'a') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=csvColumn)
        if os.path.getsize(csv1) == 0 or os.path.isfile(csv1) == False:
            writer.writeheader()
        writer.writerow(myDict)
        
except IOError:
    print("I/O error")