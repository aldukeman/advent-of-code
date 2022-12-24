import Foundation

class Input {
  struct Coord: Hashable {
    let x: Int
    let y: Int
    let z: Int

    var neighbors: [Coord] {
      [
        Coord(x: x - 1, y: y, z: z),
        Coord(x: x + 1, y: y, z: z),
        Coord(x: x, y: y - 1, z: z),
        Coord(x: x, y: y + 1, z: z),
        Coord(x: x, y: y, z: z - 1),
        Coord(x: x, y: y, z: z + 1),
      ]
    }
  }

  let locs: [Coord]

  init() {
    var blocks = [Coord]()
    while let line = readLine() {
      let vals = line.split(separator: ",").compactMap { Int($0) }
      guard vals.count == 3 else { exit(-1) }
      blocks += [Coord(x: vals[0], y: vals[1], z: vals[2])]
    }
    self.locs = blocks
  }
}

class Droplet {
  let cells: Set<Input.Coord>
  var exterior = Set<Input.Coord>()

  init(input: Input) {
    self.cells = Set(input.locs)
  }

  private func isExterior(_ coord: Input.Coord) -> Bool {
    guard !self.cells.contains(coord) else { return false }

    var frontier = [coord]
    var explored = Set<Input.Coord>()

    while let next = frontier.first {
      frontier.removeFirst()

      guard !explored.contains(next) else { continue }
      guard !self.cells.contains(next) else { continue }

      if self.exterior.contains(next) {
        self.exterior.formUnion([coord])
        return true
      } else {
        frontier += next.neighbors
        explored.formUnion([next])
      }
    }

    return false
  }

  func calculateSurfaceArea() -> Int {
    let xVals = self.cells.map { $0.x }
    let yVals = self.cells.map { $0.y }
    let zVals = self.cells.map { $0.z }

    let minX = xVals.min()! - 1
    let maxX = xVals.max()! + 1
    let minY = yVals.min()! - 1
    let maxY = yVals.max()! + 1
    let minZ = zVals.min()! - 1
    let maxZ = zVals.max()! + 1

    for x in minX...maxX {
      for y in minY...maxY {
        self.exterior.formUnion([
          Input.Coord(x: x, y: y, z: minZ),
          Input.Coord(x: x, y: y, z: maxZ),
        ])
      }
    }
    for x in minX...maxX {
      for z in minZ...maxZ {
        self.exterior.formUnion([
          Input.Coord(x: x, y: minY, z: z),
          Input.Coord(x: x, y: maxY, z: z),
        ])
      }
    }
    for y in minY...maxY {
      for z in minZ...maxZ {
        self.exterior.formUnion([
          Input.Coord(x: minX, y: y, z: z),
          Input.Coord(x: maxX, y: y, z: z),
        ])
      }
    }

    return self.cells
      .flatMap { $0.neighbors }
      .filter { self.isExterior($0) }
      .count
  }
}

print(Droplet(input: Input()).calculateSurfaceArea())
