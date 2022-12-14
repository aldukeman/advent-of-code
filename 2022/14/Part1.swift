import Foundation

struct Input {
  struct Coord: Hashable {
    let x: Int
    let y: Int
  }

  struct Rock {
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
}

extension Input {
  var maxY: Int { return self.rocks.map { max($0.topLeft.y, $0.bottomRight.y) }.max()! }
}

extension Input.Rock: SandBlockable {
  func occupies(_ coord: Input.Coord) -> Bool {
    return (coord.x >= self.topLeft.x && coord.x <= self.bottomRight.x && coord.y == self.bottomRight.y)
      || (coord.y >= self.topLeft.y && coord.y <= self.bottomRight.y && coord.x == self.bottomRight.x)
  }
}

extension Sand: SandBlockable {
  func occupies(_ coord: Input.Coord) -> Bool {
    return self.loc == coord
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
}

let input = Input()
let sandStart = Input.Coord(x: 500, y: 0)
let abyss = input.maxY + 1

var i = 0
var blocked: [SandBlockable] = input.rocks
while true {
  var newSandLoc = sandStart
  while newSandLoc.y < abyss {
    let testSandLoc = newSandLoc
      .nextCandidates
      .first { coord in
        !blocked.contains { b in
          b.occupies(coord)
        }
      }
    guard let next = testSandLoc else { break }
    newSandLoc = next
  }
  guard newSandLoc.y != abyss else { break }

  blocked += [Sand(loc: newSandLoc)]
  i += 1
}

print(i)
