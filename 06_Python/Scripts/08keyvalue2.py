import csv
import os

csvColumn = ['Naam', 'Achternaam', 'Functie', 'Bedrijf']
csv1 = "06_Python/Scripts/test.csv"
myDict = {
    "Naam" : input("Wat is jouw voornaam?\n"),
    "Achternaam" : input("Wat is jouw achternaam?\n"),
    "Functie" : input("Welke functie voer jij uit?\n"),
    "Bedrijf" : input("Bij welk bedrijf ben jij werkzaam?\n")
}
with open(csv1, 'a') as csvfile:
    writer = csv.writer(csvfile)
    if os.path.getsize(csv1) == 0 or os.path.isfile(csv1) == False:
        writer.writerow(myDict.keys())
    writer.writerow(myDict.values())