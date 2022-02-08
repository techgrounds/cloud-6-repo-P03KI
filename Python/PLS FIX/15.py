'''
The output should be:
a5|||5|||5|||a5|||5|||5|||a5|||5|||5|||
'''
foo = ''
for i in range(9):
    if i == 0 or 3 or 6:
	    foo += 'a'
	for j in range(1):
		foo += '5'
	for k in range(3):
		foo += '|'

print(foo)