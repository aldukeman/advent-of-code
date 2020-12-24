import Foundation

func range(from str: String) -> ClosedRange<Int> {
    let tokens = str.split(separator: "-")
    guard let lower = Int(tokens[0]), let upper = Int(tokens[1]) else { fatalError() }
    return ClosedRange(uncheckedBounds: (lower, upper))
}

var constraints = [String: [ClosedRange<Int>]]()

while let line = readLine() {
    guard !line.isEmpty else { break }
    
    let constraintStr = line.suffix(from: line.index(after: line.firstIndex(of: ":")!))
    
    let constriantName = line.prefix(upTo: line.firstIndex(of: ":")!)
    
    let tokens = constraintStr.split(separator: " ").compactMap { $0.isEmpty ? nil : $0 }
    let lowerRange = range(from: String(tokens[0]))
    let upperRange = range(from: String(tokens[2]))
    
    constraints[String(constriantName)] = [lowerRange, upperRange]
}

_ = readLine()
/*ticket*/_ = readLine()
_ = readLine()

var tickets = [[String]]()
_ = readLine()
while let line = readLine() {
    tickets.append(line.split(separator: ",").map { String($0) })
}

var sum = 0
for ticket in tickets {
    for v in ticket {
        let val = Int(v)!
        
        var satisfied = false
        for constraint in constraints.values {
            guard !satisfied else { break }
            for c in constraint {
                if c.contains(val) {
                    satisfied = true
                    break
                }
            }
        }
        if !satisfied {
            sum += val
        }
    }
}

print(sum)
