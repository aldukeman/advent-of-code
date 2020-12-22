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

func rotate(x: Int, y: Int, deg: Int) -> (x: Int, y: Int) {
    switch (deg + 360) % 360 {
    case 0:
        return (x: x, y: y)
    case 90:
        return (x: y, y: -x)
    case 180:
        return (x: -x, y: -y)
    case 270:
        return (x: -y, y: x)
    default:
        fatalError()
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

var boatX = 0
var boatY = 0

var waypointX = 10
var waypointY = 1

for i in instructions {
    switch i {
    case .north(let i): waypointY += i
    case .south(let i): waypointY -= i
    case .east(let i): waypointX += i
    case .west(let i): waypointX -= i
    case .left(let i):
        let new = rotate(x: waypointX, y: waypointY, deg: -i)
        waypointX = new.x
        waypointY = new.y
    case .right(let i):
        let new = rotate(x: waypointX, y: waypointY, deg: i)
        waypointX = new.x
        waypointY = new.y
    case .forward(let i):
        boatX += waypointX * i
        boatY += waypointY * i
    }
}

print(abs(boatX) + abs(boatY))
