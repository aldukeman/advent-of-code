import Foundation


let capAValue = "A".unicodeScalars.first!.value
let lowerAValue = "a".unicodeScalars.first!.value

var dupes = [UInt32]()
while let line = readLine() {
  let first = line.prefix(line.count / 2)
  let second = line.suffix(line.count / 2)

  let firstArr = first.unicodeScalars
    .map { $0.value }
    .map { $0 >= lowerAValue ? $0 - lowerAValue : $0 - capAValue + 26 }
    .map { $0 + 1 }

  let secondArr = second.unicodeScalars
    .map { $0.value }
    .map { $0 >= lowerAValue ? $0 - lowerAValue : $0 - capAValue + 26 }
    .map { $0 + 1 }

  let firstSet = Set(firstArr)
  let secondSet = Set(secondArr)

  let dupe = firstSet.intersection(secondSet)
  dupes += dupe
}

print(dupes.reduce(0,+))
