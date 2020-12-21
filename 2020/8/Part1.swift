import Foundation

enum Instruction {
    case nop
    case acc(Int)
    case jmp(Int)
    case visited
}

func processLine() -> Instruction? {
    guard let line = readLine() else { return nil }
    let tokens = line.split(separator: " ")
    guard tokens.count == 2 else { fatalError() }
    
    switch tokens[0] {
    case "nop":
        return .nop
    case "acc":
        guard let num = Int(tokens[1]) else { fatalError() }
        return .acc(num)
    case "jmp":
        guard let num = Int(tokens[1]) else { fatalError() }
        return .jmp(num)
    default:
        print(line)
        fatalError()
    }
}

var instructions = [Instruction]()

while let i = processLine() {
    instructions.append(i)
}

var acc = 0
var pc = 0
var cont = true
while cont {
    let i = instructions[pc]
    instructions[pc] = .visited
    switch i {
    case .acc(let i):
        acc += i
        pc += 1
    case .nop:
        pc += 1
    case .jmp(let i):
        pc += i
    case .visited:
        cont = false
    }
}

print(acc)
