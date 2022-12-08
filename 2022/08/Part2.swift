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

func checkCell(_ grid: [[Int]], _ x: Int, _ y: Int) -> Int {
  guard x > 0, x < (grid.count - 1), y > 0, y < (grid.first!.count - 1) else { return 0 }
  let height = grid[x][y]

  var up = 0
  for j in (0..<y).reversed() {
    up += 1
    guard grid[x][j] < height else { break }
  }

  var down = 0
  for j in (y+1)..<grid.first!.count {
    down += 1
    guard grid[x][j] < height else { break }
  }

  var left = 0
  for i in (0..<x).reversed() {
    left += 1
    guard grid[i][y] < height else { break }
  }

  var right = 0
  for i in (x+1)..<grid.count {
    right += 1
    guard grid[i][y] < height else { break }
  }

  return up * down * left * right
}

var maxVal = 0
for i in 0..<grid.count {
  let rowMax = grid[i].indices.map { checkCell(grid, i, $0) }.max()!
  maxVal = max(maxVal, rowMax)
}

print(maxVal)
