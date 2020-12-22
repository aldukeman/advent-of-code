import Foundation

var elements = Set<Int>()
let const = 2020

while let line = readLine(), let val = Int(line) {
    elements.insert(val)
}

for i in elements {
    for j in elements where i != j {
        let rem = const - i - j
        guard rem > 0 else { continue }
        if elements.contains(rem) {
            print(i * j * rem)
            exit(0)
        }
    }
}
