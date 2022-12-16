import Foundation

struct Coord: Hashable {
  let x: Int
  let y: Int

  func manhattanDistance(to other: Coord) -> Int {
    abs(self.x - other.x) + abs(self.y - other.y)
  }
}

struct BeaconSensorPair {
  let sensor: Coord
  let beacon: Coord

  var manhattanDistance: Int { self.sensor.manhattanDistance(to: self.beacon) }
}

var separationSet = CharacterSet.decimalDigits
separationSet.insert(charactersIn: "-")
separationSet.invert()

var input = [BeaconSensorPair]()
while let line = readLine() {
  let tokens = line.components(separatedBy: separationSet)
  var vals = [Int]()
  for t in tokens {
    guard let i = Int(t) else { continue }
    vals += [i]
  }
  guard vals.count == 4 else { exit(-1) }
  let sensor = Coord(x: vals[0], y: vals[1])
  let beacon = Coord(x: vals[2], y: vals[3])
  input += [BeaconSensorPair(sensor: sensor, beacon: beacon)]
}

let row = 2000000
//let row = 10
let beacons = Set(input.map { $0.beacon })
let sensors = input.map { $0.sensor }
let sensorDistances = input.map { $0.manhattanDistance }

let sensorXs = input.map { $0.sensor.x }
guard var minX = sensorXs.min() else { exit(-1) }
guard var maxX = sensorXs.max() else { exit(-1) }
minX -= sensorDistances.max()!
maxX += sensorDistances.max()!

let count = (minX...maxX)
  .map { Coord(x: $0, y: row) }
  .filter { !beacons.contains($0) }
  .filter { !sensors.contains($0) }
  .filter { testCoord in 
    let cellDistances = sensors.map { sensor in sensor.manhattanDistance(to: testCoord) }
    return zip(cellDistances, sensorDistances).contains(where: { $0 <= $1 })
  }
  .count
print(count)
