import Foundation

struct Input {
  struct Coord: Hashable {
    let x: Int
    let y: Int
  }

  struct Rock: Hashable {
    let topLeft: Coord
    let bottomRight: Coord

    init(a: Coord, b: Coord) {
      if a.x < b.x || a.y < b.y {
        self.topLeft = a
        self.bottomRight = b
      } else {
        self.topLeft = b
        self.bottomRight = a
      }
    }
  }

  let rocks: [Rock]

  init() {
    var rocksIn = [Rock]()
    while let line = readLine() {
      let coordStr = line.split(separator: "->")
      let coords = coordStr
        .map { $0.replacingOccurrences(of: " ", with: "") }
        .map {
          let vals = $0.split(separator: ",")
          guard vals.count == 2, let xVal = Int(vals[0]), let yVal = Int(vals[1]) else { exit(-1) }
          return Coord(x: xVal, y: yVal)
        }
      for i in 0..<(coords.count - 1) {
        rocksIn += [Rock(a: coords[i], b: coords[i + 1])]
      }
    }
    self.rocks = rocksIn
  }
}

struct Sand {
  let loc: Input.Coord
}

protocol SandBlockable {
  func occupies(_ coord: Input.Coord) -> Bool
  func lowestAvailable(belowY: Int, inX: Int) -> Int?
}

extension Input {
  var maxY: Int { return self.rocks.map { max($0.topLeft.y, $0.bottomRight.y) }.max()! }
}

extension Input.Rock: SandBlockable {
  var isHorizontal: Bool { self.topLeft.y == self.bottomRight.y }

  func occupies(_ coord: Input.Coord) -> Bool {
    return (coord.x >= self.topLeft.x && coord.x <= self.bottomRight.x && coord.y == self.bottomRight.y)
      || (coord.y >= self.topLeft.y && coord.y <= self.bottomRight.y && coord.x == self.bottomRight.x)
  }

  func lowestAvailable(belowY: Int, inX: Int) -> Int? {
    if self.isHorizontal {
      guard self.topLeft.x <= inX, self.bottomRight.x >= inX else { return nil }
      guard self.topLeft.y + 1 < belowY else { return nil }
      return self.topLeft.y + 1
    } else {
      guard self.topLeft.x == inX else { return nil }
      guard self.topLeft.y + 1 < belowY else { return nil }
      return self.topLeft.y + 1
    }
  }
}

extension Sand: SandBlockable {
  func occupies(_ coord: Input.Coord) -> Bool {
    return self.loc == coord
  }
 
  func lowestAvailable(belowY: Int, inX: Int) -> Int? {
    guard self.loc.x == inX else { return nil }
    guard self.loc.y + 1 < belowY else { return nil }
    return self.loc.y + 1
  }
}

extension Input.Coord {
  var nextCandidates: [Input.Coord] {
    return [
      Input.Coord(x: self.x, y: self.y + 1),
      Input.Coord(x: self.x - 1, y: self.y + 1),
      Input.Coord(x: self.x + 1, y: self.y + 1),
    ]
  }

  var diagonalCandidates: [Input.Coord] {
    return [
      Input.Coord(x: self.x - 1, y: self.y + 1),
      Input.Coord(x: self.x + 1, y: self.y + 1),
    ]
  }
}

let input = Input()
let floor = Input.Rock(a: Input.Coord(x: Int.min, y: input.maxY + 2), b: Input.Coord(x: Int.max, y: input.maxY + 2))
var blockedMap = [Int: [SandBlockable]]()
for r in (Set(input.rocks) + [floor]) {
  for y in r.topLeft.y...r.bottomRight.y {
    var blocked = blockedMap[y] ?? [SandBlockable]()
    blocked += [r]
    blockedMap[y] = blocked
  }
}

let sandStart = Input.Coord(x: 500, y: 0)
var i = 0
while true {
  i += 1
  var newSandLoc = sandStart
  while true {
    let testSandLoc = newSandLoc
      .nextCandidates
      .first { coord in
        !(blockedMap[coord.y] ?? []).contains { b in
          b.occupies(coord)
        }
      }
    guard let next = testSandLoc else { break }
    newSandLoc = next
  }
  guard newSandLoc != sandStart else { break }

  var blocked = blockedMap[newSandLoc.y] ?? [SandBlockable]()
  blocked += [Sand(loc: newSandLoc)]
  blockedMap[newSandLoc.y] = blocked
}

print(i)
