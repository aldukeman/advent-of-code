import Foundation

enum Schedule {
    case bus(Int)
    case any
}

struct Equation {
    let id: Int
    let offset: Int
    
    var rem: Int { (self.id - (self.offset % self.id)) % self.id }
}

_ = readLine()
guard let timesLine = readLine() else { fatalError() }
let idStr = timesLine.split(separator: ",")
let schedule = idStr.map { id -> Schedule in
    if id == "x" {
        return .any
    } else if let i = Int(id) {
        return .bus(i)
    } else {
        fatalError()
    }
}

let equations = schedule.enumerated().compactMap { (i, s) -> Equation? in
    switch s {
    case .bus(let id): return Equation(id: id, offset: i)
    case .any: return nil
    }
}.sorted { $0.id > $1.id }

var N = equations.first!.id
var X = equations.first!.rem
for e in equations[1...] {
    while X % e.id != e.rem {
        X += N
    }
    N *= e.id
}

print(X)
