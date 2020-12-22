import Foundation

enum Instruction {
    case north(Int)
    case south(Int)
    case east(Int)
    case west(Int)
    case left(Int)
    case right(Int)
    case forward(Int)
}

enum Heading: Int {
    case north = 0
    case east = 90
    case south = 180
    case west = 270
    
    mutating func turn(_ deg: Int) {
        var newValue = self.rawValue + deg
        if newValue < 0 {
            newValue += -(newValue / 360 - 1) * 360
        }
        self = Heading(rawValue: newValue % 360)!
    }
}

var instructions = [Instruction]()
while let line = readLine() {
    guard let i = Int(line.suffix(from: line.index(after: line.startIndex))) else { fatalError() }
    switch line.first! {
    case "N": instructions.append(.north(i))
    case "S": instructions.append(.south(i))
    case "E": instructions.append(.east(i))
    case "W": instructions.append(.west(i))
    case "L": instructions.append(.left(i))
    case "R": instructions.append(.right(i))
    case "F": instructions.append(.forward(i))
    default: fatalError()
    }
}

var heading = Heading.east
var x = 0
var y = 0

for i in instructions {
    switch i {
    case .north(let i): y += i
    case .south(let i): y -= i
    case .east(let i): x += i
    case .west(let i): x -= i
    case .left(let i): heading.turn(-i)
    case .right(let i): heading.turn(i)
    case .forward(let i):
        switch heading {
        case .north: y += i
        case .south: y -= i
        case .east: x += i
        case .west: x -= i
        }
    }
}

print(abs(x) + abs(y))
