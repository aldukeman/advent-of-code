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

func updateTailPosition(_ head: Coord, _ tail: Coord, _ lastMove: Movement) -> Coord {
  guard !head.close(tail) else { return tail }

  switch lastMove {
    case .left: return Coord(head.x + 1, head.y)
    case .right: return Coord(head.x - 1, head.y)
    case .up: return Coord(head.x, head.y - 1)
    case .down: return Coord(head.x, head.y + 1)
  }
}

var headPosition = Coord(0,0)
var tailPosition = Coord(0,0)
var prevTailPositions = Set([tailPosition])
while let line = readLine(), let movement = Movement(line) {
  let update = movement.coordUpdate()
  for _ in 0..<movement.spots {
    headPosition = update(headPosition)
    tailPosition = updateTailPosition(headPosition, tailPosition, movement)
    prevTailPositions.insert(tailPosition)
  }
}

print(prevTailPositions.count)
