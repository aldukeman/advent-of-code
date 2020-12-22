import Foundation

enum Instruction {
    case nop(Int)
    case acc(Int)
    case jmp(Int)
    case visited
}

func processLine() -> Instruction? {
    guard let line = readLine() else { return nil }
    let tokens = line.split(separator: " ")
    guard tokens.count == 2 else { fatalError() }
    guard let num = Int(tokens[1]) else { fatalError() }
    
    switch tokens[0] {
    case "nop":
        return .nop(num)
    case "acc":
        return .acc(num)
    case "jmp":
        return .jmp(num)
    default:
        print(line)
        fatalError()
    }
}

func attemptInstructions(_ instructions: [Instruction], acc: Int = 0, pc: Int = 0, hasChanged: Bool = false) -> Int? {
    guard pc != instructions.count else { return acc }
    let i = instructions[pc]
    var instructionsCopy = instructions
    instructionsCopy[pc] = .visited
    
    switch i {
    case .acc(let i):
        return attemptInstructions(instructionsCopy, acc: acc + i, pc: pc + 1, hasChanged: hasChanged)
    case .nop(let i):
        if let a = attemptInstructions(instructionsCopy, acc: acc, pc: pc + 1, hasChanged: hasChanged) {
            return a
        } else if !hasChanged {
            return attemptInstructions(instructionsCopy, acc: acc, pc: pc + i, hasChanged: true)
        } else {
            return nil
        }
    case .jmp(let i):
        if let a = attemptInstructions(instructionsCopy, acc: acc, pc: pc + i, hasChanged: hasChanged) {
            return a
        } else if !hasChanged {
            return attemptInstructions(instructionsCopy, acc: acc, pc: pc + 1, hasChanged: true)
        } else {
            return nil
        }
    case .visited:
        return nil
    }
}

var instructions = [Instruction]()

while let i = processLine() {
    instructions.append(i)
}

print(attemptInstructions(instructions) ?? "<invalid>")
