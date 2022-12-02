import Foundation

var cals = [Int]()

var calCount = 0
while let line = readLine() {
  if line.isEmpty {
    cals += [calCount]
    calCount = 0
  } else {
    let val = Int(line)!
    calCount += val
  }
}

cals += [calCount]
print(cals.max())
