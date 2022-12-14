import Foundation

struct Input {
  enum Packet {
    case val(Int)
    case list([Packet])

    init(_ str: String) {
      if str.first == "[" {
        var closing = 1
        var idx = 0
        while closing != 0 {
          idx += 1
          let c = str[str.index(str.startIndex, offsetBy: idx)]
          if c == "[" {
            closing += 1
          } else if c == "]" {
            closing -= 1
          }
	}
        guard idx != 1 else { self = .list([]); return }

        let index1 = str.index(str.startIndex, offsetBy: 1)
        let indexIdx = str.index(str.startIndex, offsetBy: idx)
        let innerPackets = Packet.generateEntries(String(str[index1..<indexIdx]))
          .map { Packet($0) }
        self = .list(innerPackets)
      } else if let val = Int(str) {
        self = .val(val)
      } else {
        exit(-1)
      }
    }

    private static func generateEntries(_ str: String) -> [String] {
      let csv = str.split(separator: ",")
      var entries = [String]()
      
      var open = 0
      var cur = [String]()
      for v in csv {
        cur += [String(v)]
        open += v.filter { $0 == "[" }.count
        open -= v.filter { $0 == "]" }.count
        if open == 0 {
          entries += [cur.joined(separator: ",")]
          cur = []
        }
      }

      return entries
    }

    func debug() -> String {
      switch self {
      case .val(let i): return "\(i)"
      case .list(let l): return "[\(l.map { $0.debug() }.joined(separator: ","))]"
      }
    }
  }

  struct MessagePair {
    let left: Packet
    let right: Packet
  }

  let pairs: [MessagePair]

  init?() {
    var pairs = [MessagePair]()
    while let leftLine = readLine() {
      guard let rightLine = readLine() else { exit(-1) }
      _ = readLine()

      pairs += [MessagePair(left: Packet(leftLine), right: Packet(rightLine))]
    }

    self.pairs = pairs
  }
}

enum Order {
  case less
  case equal
  case greater
}

func isOrdered(lhs: Input.Packet, rhs: Input.Packet) -> Order {
  switch (lhs, rhs) {
    case (.val(let l), .val(let r)):
      if l < r {
        return .less
      } else if l == r {
        return .equal
      } else {
        return .greater
      }
    case (.list(let l), .list(let r)):
      for (lVal, rVal) in zip(l, r) {
        switch isOrdered(lhs: lVal, rhs: rVal) {
          case .less: return .less
          case .equal: continue
          case .greater: return .greater
        }
      }

      if l.count < r.count {
        return .less
      } else if l.count == r.count {
        return .equal
      } else {
        return .greater
      }
    case (.val, .list):
      return isOrdered(lhs: .list([lhs]), rhs: rhs)
    case (.list, .val):
      return isOrdered(lhs: lhs, rhs: .list([rhs]))
  }
}

guard let input = Input() else { exit(-1) }
let s = input
  .pairs
  .enumerated()
  .filter { isOrdered(lhs: $0.1.left, rhs: $0.1.right) == .less }
  .map { $0.0 }
  .map { $0 + 1 }
  .reduce(0,+)
print(s)
