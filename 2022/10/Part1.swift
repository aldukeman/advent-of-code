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

var sigStrengths = [Int]()
var xVal = 1
var cycle = 0
while let line = readLine(), let instr = Instruction(line), cycle < 221 {
  let incr: Int
  switch instr {
    case .addx(let val): incr = val
    case .noop: incr = 0
  }

  for _ in 0..<instr.cycles {
    cycle += 1
    if cycle % 40 == 20 {
      sigStrengths += [xVal * cycle]
    }
  }

  xVal += incr
}

print(sigStrengths.reduce(0,+))
