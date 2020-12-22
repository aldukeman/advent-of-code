import Foundation

func array(_ arr: [Int], hasPairSumming sum: Int) -> Bool {
    var elements = Set<Int>()
    for a in arr {
        let needed = sum - a
        if elements.contains(needed) {
            return true
        } else {
            elements.insert(a)
        }
    }
    return false
}

var ints = [Int]()
let preamble = 25
for _ in 0..<preamble {
    guard let line = readLine() else { break }
    guard let i = Int(line) else { print(line); fatalError() }
    ints.append(i)
}

while let line = readLine() {
    guard let i = Int(line) else { print(line); fatalError() }
    guard array(ints, hasPairSumming: i) else { print(i); break }
    ints.removeFirst()
    ints.append(i)
}
