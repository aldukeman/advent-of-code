import Foundation

struct Coord: Hashable {
  let x: Int
  let y: Int

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.x)
    hasher.combine(self.y)
  }

  func close(_ other: Coord) -> Bool {
    return abs(self.x - other.x) <= 1 && abs(self.y - other.y) <= 1
  }
}

struct Input {
  let grid: [[Int]]
  let start: Coord
  let end: Coord
}

func readInput() -> Input? {
  var grid = [[Int]]()
  
  var idx = 0
  var start: Coord?
  var end: Coord?
  
  let lowerAValue = "a".unicodeScalars.first!.value
  let upperSValue = "S".unicodeScalars.first!.value
  let upperEValue = "E".unicodeScalars.first!.value
  while var line = readLine() {
    let lineUnicodeValues = line.unicodeScalars.map { $0.value }
    if let startIdx = lineUnicodeValues.firstIndex(of: upperSValue) {
      start = Coord(x: idx, y: Int(startIdx))
    }
    if let endIdx = lineUnicodeValues.firstIndex(of: upperEValue) {
      end = Coord(x: idx, y: Int(endIdx))
    }
  
    line = line.replacingOccurrences(of: "S", with: "a")
    line = line.replacingOccurrences(of: "E", with: "z")
  
    let row = line
      .unicodeScalars
      .map { $0.value }
      .map { Int($0 - lowerAValue) }
    grid += [row]
    idx += 1
  }

  guard let s = start, let e = end else { return nil }
  return Input(grid: grid, start: s, end: e)
}

guard let input = readInput() else { exit(-1) }

class Node {
  let g: Int
  let coord: Coord
  let prior: Node?

  init(g: Int, coord: Coord, prior: Node?) {
    self.g = g
    self.coord = coord
    self.prior = prior
  }

  var h: Int { 0 }
  var f: Int { self.g + self.h }

  func pathFromStart() -> [Coord] {
    guard let p = prior else { return [self.coord] }
    return p.pathFromStart() + [self.coord]
  }

  func debug() {
    print("g: \(self.g), h: \(self.h), f: \(self.f), coord: \(self.coord)")
  }
}

func astar(start: Coord, endHeight: Int, grid: [[Int]]) -> [Coord]? {
  var frontier = [Node(g: 0, coord: start, prior: nil)]
  var visited = Set<Coord>()

  while let next = frontier.first {
    guard grid[next.coord.x][next.coord.y] != endHeight else { return next.pathFromStart() }
    frontier.removeFirst()
    guard !visited.contains(next.coord) else { continue }
    visited.insert(next.coord)

    let down = Coord(x: next.coord.x + 1, y: next.coord.y)
    let up = Coord(x: next.coord.x - 1, y: next.coord.y)
    let left = Coord(x: next.coord.x, y: next.coord.y - 1)
    let right = Coord(x: next.coord.x, y: next.coord.y + 1)
  
    let curHeight = grid[next.coord.x][next.coord.y]
    let nextCoords: [Coord] = [down, up, left, right]
      .filter { $0.x <= (grid.count - 1) && $0.x >= 0 && $0.y <= (grid.first!.count - 1) && $0.y >= 0 }
      .filter { grid[$0.x][$0.y] + 1 >= curHeight }
      .filter { !visited.contains($0) }

    nextCoords.forEach { frontier += [Node(g: next.g + 1, coord: $0, prior: next)] }
  
    frontier.sort(by: { $0.f < $1.f })
  }

  return nil
}

let path = astar(start: input.end, endHeight: 0, grid: input.grid)
print((path?.count ?? 0) - 1)
