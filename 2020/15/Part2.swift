import Foundation

struct Seq {
    let former: Int?
    let latter: Int
}

guard let line = readLine() else { fatalError() }
let numStrs = line.split(separator: ",")
let startingNums = numStrs.map { Int($0)! }
guard !startingNums.isEmpty else { fatalError() }

var lastTurn = [Int: Seq]()

var turn = 0
for i in startingNums {
    lastTurn[i] = Seq(former: nil, latter: turn)
    turn += 1
}

var prev = startingNums.last!
for i in turn..<30000000 {
    let cur: Int
    let s = lastTurn[prev]!
    if let f = s.former {
        cur = s.latter - f
    } else {
        cur = 0
    }
    
    if let s = lastTurn[cur] {
        lastTurn[cur] = Seq(former: s.latter, latter: i)
    } else {
        lastTurn[cur] = Seq(former: nil, latter: i)
    }
    prev = cur
}

print(prev)
