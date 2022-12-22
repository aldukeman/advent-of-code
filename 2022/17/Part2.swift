import Foundation

class Input {
  enum Direction {
    case left
    case right
  }

  struct Block {
    let cells: [[Bool]]
    var height: Int { self.cells.count }
    var width: Int { self.cells.first!.count }
  
    init(block: [[Bool]]) {
      self.cells = block
    }
  
    func debug() {
      print(self.height)
      print(self.width)
      for row in self.cells {
        print(row.map { $0 ? "#" : "." }.joined(separator: ""))
      }
    }
  }
  
  let blocks = [
    Block(
      block: [
        [true, true, true, true]
      ]
    ),
    Block(
      block: [
        [false, true, false],
        [true, true, true],
        [false, true, false],
      ]
    ),
    Block(
      block: [
        [false, false, true],
        [false, false, true],
        [true, true, true],
      ]
    ),
    Block(
      block: [
        [true],
        [true],
        [true],
        [true],
      ]
    ),
    Block(
      block: [
        [true, true],
        [true, true],
      ]
    ),
  ]

  let directions: [Direction]
  let width: Int
  let numRocks: Int
  let xOffset: Int
  let yOffset: Int

  init(width: Int, numRocks: Int, xOffset: Int, yOffset: Int) {
    self.width = width
    self.numRocks = numRocks
    self.xOffset = xOffset
    self.yOffset = yOffset

    guard let line = readLine() else { exit(-1) }
    self.directions = line.map { $0 == "<" ? .left : .right }
  }
}

class World {
  struct Coord {
    let x: Int
    let y: Int
  
    func down() -> Coord { Coord(x: x, y: y - 1) }
    func apply(dir: Input.Direction) -> Coord {
      switch dir {
      case .left: return Coord(x: x - 1, y: y)
      case .right: return Coord(x: x + 1, y: y)
      }
    }
  }
  
  struct CycleKey: Hashable {
    let block: Int
    let jet: Int
    let topOfStack: [[Bool]]

    func hash(into hasher: inout Hasher) {
      hasher.combine(block)
      hasher.combine(jet)
      hasher.combine(topOfStack)
    }
  }

  struct CycleValue {
    let stageHeight: Int
    let blockNum: Int
  }

  private let input: Input
  private var stage: [[Bool]]

  private var excessHeight: Int { self.stage.reversed().firstIndex { $0.contains(true) }! }
  private var height: Int { self.stage.count - self.excessHeight }

  init(input: Input) {
    self.input = input
    self.stage = [[Bool](repeating: true, count: input.width)]
  }

  func run() -> Int {
    var jetDirIdx = 0
    var heightOffset = 0
    var cycles = [CycleKey: CycleValue]()
    let cycleKeyHeight = 100

    var i = 0
    while i < input.numRocks {
      let block = input.blocks[i % input.blocks.count]
      let requiredHeight = block.height + input.yOffset
      if requiredHeight > self.excessHeight {
        let extra = requiredHeight - self.excessHeight
        self.stage += [[Bool]](repeating: [Bool](repeating: false, count: input.width), count: extra)
      }
      self.drop(block: block, jetDirIdx: &jetDirIdx)
      i += 1

      if heightOffset == 0, self.height > cycleKeyHeight {
        let stageStart = self.height - cycleKeyHeight
        let cycleKey = CycleKey(block: i % input.blocks.count,
                                jet: jetDirIdx % input.directions.count,
                                topOfStack: Array(self.stage[stageStart..<self.height]))
        if let cycleValue = cycles[cycleKey] {
          let cycleHeight = self.height - cycleValue.stageHeight
          let cycleBlocks = i - cycleValue.blockNum
          let mult: Int = (input.numRocks - i) / cycleBlocks
          i += mult * cycleBlocks
          heightOffset = mult * cycleHeight
        } else {
          cycles[cycleKey] = CycleValue(stageHeight: self.height, blockNum: i)
        }
      }
    }

    return self.height - 1 + heightOffset
  }

  private func debugStage() {
    for s in self.stage.reversed() {
      print(s.map { $0 ? "#" : "." }.joined(separator: ""))
    }
    print()
  }

  private func drop(block: Input.Block, jetDirIdx: inout Int) {
    var topLeftCoord = Coord(x: input.xOffset, y: self.height + block.height + input.yOffset - 1)
    while true {
      var test = topLeftCoord.apply(dir: input.directions[jetDirIdx % input.directions.count])
      jetDirIdx += 1
      if isPositionValid(block: block, coord: test) {
        topLeftCoord = test
      }

      test = topLeftCoord.down()
      if !isPositionValid(block: block, coord: test) {
        place(block: block, coord: topLeftCoord)
        return
      }
      topLeftCoord = test
    }
  }

  private func isPositionValid(block: Input.Block, coord: Coord) -> Bool {
    guard coord.x >= 0 else { return false }
    guard coord.x + block.width <= input.width else { return false }

    for i in 0..<block.height {
      for j in 0..<block.width where block.cells[i][j] {
        if self.stage[coord.y - i][coord.x + j] {
          return false
        }
      }
    }
    return true
  }

  private func place(block: Input.Block, coord: Coord) {
    for i in 0..<block.height {
      for j in 0..<block.width where block.cells[i][j] {
        self.stage[coord.y - i][coord.x + j] = true
      }
    }
  }
}

let input = Input(width: 7, numRocks: 1_000_000_000_000, xOffset: 2, yOffset: 3)
print(World(input: input).run())
