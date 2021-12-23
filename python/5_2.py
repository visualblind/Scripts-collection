### assignment 5.2 (final)
print('note: type `done` to end')
largest = None
smallest = None
while True:
    num = input("Enter a number: ")
    if num == "done":
        break
    try:
        fval = int(num)
    except:
        print('Invalid input')
        continue
    # print(fval)
    if smallest is None:
        smallest = fval
        s = int(smallest)
    elif fval < s:
        s = fval
    if largest is None:
        largest = fval
        l = int(largest)
    elif fval > l:
        l = fval

print("Maximum", l)
print("Minimum", s)
