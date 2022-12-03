import Foundation

let capAValue = "A".unicodeScalars.first!.value
let lowerAValue = "a".unicodeScalars.first!.value

let allValues = Set<UInt32>(1...52)
var badges = [UInt32]()
while let firstLine = readLine() {
  let badge = [firstLine, readLine(), readLine()]
    .compactMap { $0 }
    .map { line in
      line.unicodeScalars
        .map { $0.value }
        .map { $0 >= lowerAValue ? $0 - lowerAValue : $0 - capAValue + 26 }
        .map { $0 + 1 }
    }
    .map { Set($0) }
    .reduce(allValues) { $0.intersection($1) }

  badges += badge
}

print(badges.reduce(0,+))
