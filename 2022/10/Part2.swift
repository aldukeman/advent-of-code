import Foundation

enum Instruction {
  case addx(Int)
  case noop

  init?(_ line: String) {
    let tokens = line.split(separator: " ")
    switch tokens[0] {
      case "noop": self = .noop
      case "addx": self = .addx(Int(tokens[1])!)
      default: return nil
    }
  }

  var cycles: Int {
    switch self {
      case .addx: return 2
      case .noop: return 1
    }
  }
}

var rendering = [String]()
var xVal = 1
var cycle = 0
while let line = readLine(), let instr = Instruction(line) {
  let incr: Int
  switch instr {
    case .addx(let val): incr = val
    case .noop: incr = 0
  }

  for _ in 0..<instr.cycles {
    if cycle % 40 == 0 {
      rendering += [""]
    }

    if abs(xVal - cycle % 40) <= 1 {
      rendering[cycle / 40] += "#"
    } else {
      rendering[cycle / 40] += "."
    }

    cycle += 1
  }

  xVal += incr
}

for r in rendering {
  print(r)
}
