end = False

while end == False:
    x = int(input("Raad het getal! Voer een getal in: "))
    if x <= 99 :
        print(str(x) + " is misschien wat aan de lage kant, niet?")
    elif x == 100 :
        print("Je hebt het getal geraden! Het spel wordt nu gestopt.")
        end = True
    else : 
        print("Wauw! " + str(x) + " is inderdaad een groot getal!")

"""
end = False
while end == False:
    print("Wat is je leeftijd?")
    x = input()
    if x < "40":
        print("Je bent " + str(40-int(x)) + " jaar jonger dan mij!")
    elif x == "100":
        print("Ik geloof je niet.")
        end = True
        print(end)
    elif x > "40": 
        print("Je bent " + str(int(x)-40) + " jaar ouder dan mij!")
    else: 
        print("Je bent even oud als mij")
"""