import Foundation

extension Array where Element == Cell {
    func printContents() {
        var str = ""
        for i in self {
            switch i {
            case .occupied:
                str += "#"
            case .available:
                str += "L"
            case .floor:
                str += "."
            }
        }
        print(str)
    }
}

extension Array where Element == [Cell] {
    func printContents() {
        for i in self {
            i.printContents()
        }
    }
}

enum Cell: Equatable {
    case occupied
    case available
    case floor
}

func findFirstNonFloor(state: [[Cell]], i: Int, deltaI: Int, j: Int, deltaJ: Int) -> (i: Int, j: Int)? {
    var iTest = i
    var jTest = j
    while iTest >= 0, iTest < state.count, jTest >= 0, jTest < state[iTest].count {
        switch state[iTest][jTest] {
        case .occupied, .available:
            return (i: iTest, j: jTest)
        case .floor:
            break
        }
        iTest += deltaI
        jTest += deltaJ
    }
    return nil
}

func adjacentCells(state: [[Cell]], i: Int, j: Int) -> [(i: Int, j: Int)] {
    var ret = [(i: Int, j: Int)]()
    for iIter in -1...1 {
        for jIter in -1...1 {
            guard iIter != 0 || jIter != 0 else { continue }
            guard let adj = findFirstNonFloor(state: state, i: i + iIter, deltaI: iIter, j: j + jIter, deltaJ: jIter) else { continue }
            ret += [adj]
        }
    }
    return ret
}

func iterate(state: [[Cell]]) -> [[Cell]] {
    return state.enumerated().map { (i, row) -> [Cell] in
        row.enumerated().map { (j, col) -> Cell in
            guard state[i][j] != .floor else { return .floor }
                                    
            var adjacentOccupied = 0
            for adj in adjacentCells(state: state, i: i, j: j) {
                if state[adj.i][adj.j] == .occupied {
                    adjacentOccupied += 1
                }
            }
            
            switch state[i][j] {
            case .available:
                if adjacentOccupied == 0 {
                    return .occupied
                }
            case .occupied:
                if adjacentOccupied >= 5 {
                    return .available
                }
            case .floor:
                fatalError()
            }
            return state[i][j]
        }
    }
}

var state = [[Cell]]()
var lineIdx = 0
while let line = readLine() {
    let row = line.map({ c -> Cell in
        switch c {
        case "L":
            return .available
        case ".":
            return .floor
        default:
            fatalError()
        }
    })
    state.append(row)
    lineIdx += 1
}

var old = [[Cell]]()
var new = state

while old != new {
    old = new
    new = iterate(state: old)
}

let numOccupied = new.reduce(0) { r, row -> Int in
    return r + row.reduce(0) { $0 + ($1 == .occupied ? 1 : 0) }
}
print(numOccupied)
