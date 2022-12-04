import Foundation

struct Range {
  let lower: Int
  let upper: Int

  init?(_ str: String) {
    let bounds = str.split(separator: "-")
    guard let lower = Int(bounds.first ?? ""),
      let upper = Int(bounds.last ?? "") else {
        return nil
      }

    self.lower = lower
    self.upper = upper
  }

  func contains(_ range: Range) -> Bool {
    return self.lower <= range.lower && self.upper >= range.upper
  }
}

var count = 0
while let line = readLine() {
  let ranges = line
    .split(separator: ",")
    .map { String($0) }
    .compactMap { Range($0) }

  assert(ranges.count == 2)

  if ranges[0].contains(ranges[1]) || ranges[1].contains(ranges[0]) {
    count += 1
  }
}

print(count)
