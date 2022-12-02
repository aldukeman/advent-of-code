import Foundation

enum Result {
  case win
  case lose
  case draw

  init?(_ char: String) {
    switch char {
      case "X": self = .lose
      case "Y": self = .draw
      case "Z": self = .win
      default: return nil
    }
  }

  func score() -> Int {
    switch self {
      case .win: return 6
      case .lose: return 0
      case .draw: return 3
    }
  }
}

enum Choice {
  case rock
  case paper
  case scissors

  init?(_ char: String) {
    switch char {
      case "A": self = .rock
      case "B": self = .paper
      case "C": self = .scissors
      default: return nil
    }
  }

  func choiceFor(result: Result) -> Choice {
    switch result {
      case .win:
        switch self {
          case .rock: return .paper
          case .paper: return .scissors
          case .scissors: return .rock
        }
      case .lose:
        switch self {
          case .rock: return .scissors
          case .paper: return .rock
          case .scissors: return .paper
        }
      case .draw: return self
    }
  }

  func choiceScore() -> Int {
    switch self {
      case .rock: return 1
      case .paper: return 2
      case .scissors: return 3
    }
  }
}

var lines = [String]()
while let line = readLine() {
  lines += [line]
}

var score = lines.map { $0.split(separator: " ") }
  .map {
    let lhs = Choice(String($0[0]))!
    let result = Result(String($0[1]))!
    let rhs = lhs.choiceFor(result: result)
    return result.score() + rhs.choiceScore()
  }
  .reduce(0, +)
print(score)
