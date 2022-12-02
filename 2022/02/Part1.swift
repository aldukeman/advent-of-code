import Foundation

enum Choice {
  case rock
  case paper
  case scissors

  init?(_ char: String) {
    switch char {
      case "A", "X": self = .rock
      case "B", "Y": self = .paper
      case "C", "Z": self = .scissors
      default: return nil
    }
  }

  func choiceScore() -> Int {
    switch self {
      case .rock: return 1
      case .paper: return 2
      case .scissors: return 3
    }
  }

  func resultScore(_ other: Choice) -> Int {
    switch (self, other) {
      case (.rock, .rock): return 3
      case (.rock, .paper): return 0 
      case (.rock, .scissors): return 6
      case (.paper, .rock): return 6
      case (.paper, .paper): return 3
      case (.paper, .scissors): return 0
      case (.scissors, .rock): return 0
      case (.scissors, .paper): return 6
      case (.scissors, .scissors): return 3
    }
  }

  static func score(lhs: Choice, rhs: Choice) -> Int {
    return rhs.choiceScore() + rhs.resultScore(lhs)
  }
}

var lines = [String]()
while let line = readLine() {
  lines += [line]
}

var score = lines.map { $0.split(separator: " ") }
  .map { Choice.score(lhs: Choice(String($0[0]))!, rhs: Choice(String($0[1]))!) }
  .reduce(0, +)
print(score)
