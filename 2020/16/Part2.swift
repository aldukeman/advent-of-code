import Foundation

struct Constraint: Equatable {
    let lower: ClosedRange<Int>
    let upper: ClosedRange<Int>
    let name: String
    var fields = [Int]()
    
    init(lower: ClosedRange<Int>, upper: ClosedRange<Int>, name: String) {
        self.lower = lower
        self.upper = upper
        self.name = name
    }
    
    func contains(_ i: Int) -> Bool {
        return self.lower.contains(i) || self.upper.contains(i)
    }
}

func range(from str: String) -> ClosedRange<Int> {
    let tokens = str.split(separator: "-")
    guard let lower = Int(tokens[0]), let upper = Int(tokens[1]) else { fatalError() }
    return ClosedRange(uncheckedBounds: (lower, upper))
}

func valid(fields: [[Int]], constraint: Constraint) -> [Int] {
    var valid = [Int]()
    for (i, f) in fields.enumerated() {
        var val = true
        for v in f where !constraint.contains(v) {
            val = false
        }
        if val {
            valid += [i]
        }
    }
    return valid
}

func guess(applied: [Constraint], remaining: [Constraint], fieldNum: Int = 0) -> [Constraint]? {
    guard !remaining.isEmpty else { return applied }
            
    for c in remaining.filter({ $0.fields.contains(fieldNum) }) {
        var remCopy = remaining
        remCopy.remove(at: remCopy.firstIndex(of: c)!)
        if let applied = guess(applied: applied + [c], remaining: remCopy, fieldNum: fieldNum + 1) {
            return applied
        }
    }
    
    return nil
}

var constraints = [Constraint]()

while let line = readLine() {
    guard !line.isEmpty else { break }
    
    let constraintStr = line.suffix(from: line.index(after: line.firstIndex(of: ":")!))
    
    let tokens = constraintStr.split(separator: " ").compactMap { $0.isEmpty ? nil : $0 }
    let lowerRange = range(from: String(tokens[0]))
    let upperRange = range(from: String(tokens[2]))
    
    let constriantName = line.prefix(upTo: line.firstIndex(of: ":")!)
    
    constraints.append(Constraint(lower: lowerRange, upper: upperRange, name: String(constriantName)))
}

_ = readLine()
guard let myTicketStr = readLine() else { fatalError() }
let myTicket = myTicketStr.split(separator: ",").map { Int($0)! }
_ = readLine()

var tickets = [[Int]]()
_ = readLine()
while let line = readLine() {
    tickets.append(line.split(separator: ",").map { Int($0)! })
}

let filteredTickets = tickets.filter { ticket -> Bool in
    ticket.allSatisfy { val -> Bool in
        constraints.contains { $0.contains(val) }
    }
}

var fields = [[Int]](repeating: [Int](repeating: 0, count: filteredTickets.count), count: tickets.first!.count)
for i in 0..<tickets.first!.count {
    for j in 0..<filteredTickets.count {
        fields[i][j] = filteredTickets[j][i]
    }
}

for i in 0..<constraints.count {
    constraints[i].fields = valid(fields: fields, constraint: constraints[i])
}

constraints.sort(by: { $0.fields.count < $1.fields.count })

let appliedFields = guess(applied: [], remaining: constraints)!.map { $0.name }

var departureFields = [Int]()
for (i, f) in appliedFields.enumerated() where f.hasPrefix("departure") {
    departureFields.append(myTicket[i])
}

print(departureFields.reduce(1, { $0 * $1 }))
