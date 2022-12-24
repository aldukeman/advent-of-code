import Foundation

class Input {
  struct Coord: Hashable {
    let x: Int
    let y: Int
    let z: Int
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

  init(input: Input) {
    self.cells = Set(input.locs)
  }

  func calculateSurfaceArea() -> Int {
    cells
      .flatMap {
        [
          Input.Coord(x: $0.x + 1, y: $0.y, z: $0.z),
          Input.Coord(x: $0.x - 1, y: $0.y, z: $0.z),
          Input.Coord(x: $0.x, y: $0.y + 1, z: $0.z),
          Input.Coord(x: $0.x, y: $0.y - 1, z: $0.z),
          Input.Coord(x: $0.x, y: $0.y, z: $0.z + 1),
          Input.Coord(x: $0.x, y: $0.y, z: $0.z - 1),
        ]
      }
      .filter { !self.cells.contains($0) }
      .count
  }
}

print(Droplet(input: Input()).calculateSurfaceArea())
