def function(y):
    i = 0
    while i < len(y):
        if i != int(len(y)-1):
            print("1=" + str(reeks[i]) + " en 2=" + str(reeks[i+1]) + " en samen is dat " + str(reeks[i] + reeks[i+1]))
            i += 1
        else:
            print("1=" + str(reeks[i]) + " en 2=" + str(reeks[0]) + " en samen is dat " + str(reeks[i] + reeks[0]))
            i += 1
        
reeks = [122, 34, 5, 752, 303]
function(reeks)
