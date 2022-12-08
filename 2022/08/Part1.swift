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
}

func transpose(_ matrix: [[Int]]) -> [[Int]] {
  var result = [[Int]](repeating: [Int](repeating: 0, count: matrix.count), count: matrix.first!.count)
  for i in 0..<matrix.count {
    for j in  0..<matrix.first!.count {
      result[j][i] = matrix[i][j]
    }
  }
  return result
}

var grid = [[Int]]()
while let line = readLine() {
  var row = [Int]()
  for c in line {
    guard let i = Int(String(c)) else { exit(-1) }
    row += [i]
  }
  grid += [row]
}

func checkRow(_ grid: [[Int]], _ x: Int, _ y: Int) -> Bool {
  guard y > 0, y < grid.first!.count else { return true }
  guard let maxLeft = grid[x][0..<y].max() else { return true }
  let height = grid[x][y]
  if height > maxLeft { return true }
  guard let maxRight = grid[x][(y+1)..<grid.first!.count].max() else { return true }
  return height > maxRight
}

var visibleTrees = Set<Coord>()
for i in 0..<grid.count {
  for j in 0..<grid.first!.count where checkRow(grid, i, j) {
    visibleTrees.insert(Coord(i, j))
  }
}

let gridTransposed = transpose(grid)
for i in 0..<gridTransposed.count {
  for j in 0..<gridTransposed.first!.count where !visibleTrees.contains(Coord(j, i)) && checkRow(gridTransposed, i, j) {
    visibleTrees.insert(Coord(j, i))
  }
}

print(visibleTrees.count)
