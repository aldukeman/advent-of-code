import Foundation

struct Coord: Hashable {
  let x: Int
  let y: Int

  init(_ a: Int, _ b: Int) {
    self.x = a
    self.y = b
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.x)
    hasher.combine(self.y)
  }

  func close(_ other: Coord) -> Bool {
    return abs(self.x - other.x) <= 1 && abs(self.y - other.y) <= 1
  }

  static func -(lhs: Coord, rhs: Coord) -> Coord {
    return Coord(lhs.x - rhs.x, lhs.y - rhs.y)
  }

  static func +(lhs: Coord, rhs: Coord) -> Coord {
    return Coord(lhs.x + rhs.x, lhs.y + rhs.y)
  }
}

enum Movement {
  case left(Int)
  case right(Int)
  case up(Int)
  case down(Int)

  init?(_ line: String) {
    let tokens = line.split(separator: " ")
    switch tokens[0] {
      case "L": self = .left(Int(tokens[1])!)
      case "R": self = .right(Int(tokens[1])!)
      case "U": self = .up(Int(tokens[1])!)
      case "D": self = .down(Int(tokens[1])!)
      default: return nil
    }
  }

  func coordUpdate() -> (Coord) -> Coord {
    switch self {
      case .left: return { Coord($0.x - 1, $0.y) }
      case .right: return { Coord($0.x + 1, $0.y) }
      case .up: return { Coord($0.x, $0.y + 1) }
      case .down: return { Coord($0.x, $0.y - 1) }
    }
  }

  var spots: Int {
    switch self {
    case .left(let s): return s
    case .right(let s): return s
    case .up(let s): return s
    case .down(let s): return s
    }
  }
}

func updateKnotPosition(_ head: Coord, _ tail: Coord) -> Coord {
  guard !head.close(tail) else { return tail }

  let newX: Int
  if head.x > tail.x {
    newX = tail.x + 1
  } else if head.x < tail.x {
    newX = tail.x - 1
  } else {
    newX = tail.x
  }

  let newY: Int
  if head.y > tail.y {
    newY = tail.y + 1
  } else if head.y < tail.y {
    newY = tail.y - 1
  } else {
    newY = tail.y
  }

  return Coord(newX, newY)
}

var headPosition = Coord(0,0)
var knotPositions = [Coord](repeating: Coord(0,0), count: 9)
var prevTailPositions = Set(knotPositions)
while let line = readLine(), let movement = Movement(line) {
  let update = movement.coordUpdate()
  for _ in 0..<movement.spots {
    headPosition = update(headPosition)
    knotPositions[0] = updateKnotPosition(headPosition, knotPositions[0])
    for i in 1..<knotPositions.count {
      knotPositions[i] = updateKnotPosition(knotPositions[i-1], knotPositions[i])
    }
    prevTailPositions.insert(knotPositions.last!)
  }
}

print(prevTailPositions.count)
