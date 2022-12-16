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

let row = 2000000; let maxCoord = 4000000
//let row = 10; let maxCoord = 20

let beacons = Set(input.map { $0.beacon })
let sensors = input.map { $0.sensor }
let sensorDistances = input.map { $0.manhattanDistance }

let sensorXs = input.map { $0.sensor.x }
guard var minX = sensorXs.min() else { exit(-1) }
guard var maxX = sensorXs.max() else { exit(-1) }
minX -= sensorDistances.max()!
maxX += sensorDistances.max()!
minX = max(0, minX)
maxX = min(maxCoord, maxX)

let sensorYs = input.map { $0.sensor.y }
guard var minY = sensorYs.min() else { exit(-1) }
guard var maxY = sensorYs.max() else { exit(-1) }
minY -= sensorDistances.max()!
maxY += sensorDistances.max()!
minY = max(0, minY)
maxY = min(maxCoord, maxY)

let sensorsByDistance = input.sorted { $0.manhattanDistance < $1.manhattanDistance }
let maxDist = 1
let potentialDistressCoords = (1...maxDist)
  .lazy
  .flatMap { offset in 
    sensorsByDistance
      .lazy
      .flatMap { input in 
        let dist = input.manhattanDistance + offset
        return (-dist...dist)
          .flatMap { xOffset in
            let yOffset = abs(abs(xOffset) - dist)
            let upCoord = Coord(x: input.sensor.x + xOffset, y: input.sensor.y - yOffset)
            let downCoord = Coord(x: input.sensor.x + xOffset, y: input.sensor.y + yOffset)
            return Set([upCoord, downCoord])
          }
      }
  }

let filteredCoords = potentialDistressCoords
  .filter { $0.x >= 0 && $0.x <= maxCoord && $0.y >= 0 && $0.y <= maxCoord }
  .filter { !beacons.contains($0) }
  .filter { !sensors.contains($0) }

let distressSource = filteredCoords
  .first { testCoord in 
    let testDistances = sensors.map { $0.manhattanDistance(to: testCoord) }
    return !zip(testDistances, sensorDistances).contains { $0 <= $1 }
  }

print(distressSource!.x * 4000000 + distressSource!.y)
