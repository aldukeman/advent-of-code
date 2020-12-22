import Foundation

var elements = Set<Int>()

while let line = readLine(), let val = Int(line) {
    let needed = 2020 - val
    if elements.contains(needed) {
        print(needed * val)
        exit(0)
    } else {
        elements.insert(val)
    }
}
