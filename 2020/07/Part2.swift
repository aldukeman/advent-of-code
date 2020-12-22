import Foundation

func processLine() -> (holder: String, holdees: [String: Int])? {
    guard let line = readLine() else { return nil }
    guard let idx = line.range(of: " contain") else { return nil }
    let holder = line.prefix(upTo: idx.lowerBound)
    let bags = line.suffix(from: idx.upperBound).trimmingCharacters(in: CharacterSet(charactersIn: "."))
    
    guard let valIdx = holder.range(of: " bags") else { return nil }
    let valColor = String(holder.prefix(upTo: valIdx.lowerBound))
        
    var bagTokens = bags.split(separator: ",").map { String($0) }
    if bagTokens.isEmpty {
        bagTokens += [bags]
    }
    
    var holdees = [String: Int]()
    for b in bagTokens {
        let c = b.dropFirst().replacingOccurrences(of: " bags", with: "")
        if c != "no other" {
            let tokens = c.split(separator: " ")
            guard let num = Int(tokens.first!) else { continue }
            let name = "\(tokens[1]) \(tokens[2])"
            holdees[name] = num
        }
    }
    
    return (holder: valColor, holdees: holdees)
}

var holders = [String: [String: Int]]()

while let s = processLine() {
    holders[s.holder] = s.holdees
}

var processed = Set<String>()
struct Bag {
    let color: String
    let count: Int
}
var toProcess = [Bag(color: "shiny gold", count: 1)]

var numHeld = 0
while let bag = toProcess.first {
    toProcess.removeFirst()
    
    numHeld += bag.count

    guard let held = holders[bag.color] else { continue }
    for (k, v_2) in held {
        toProcess.append(Bag(color: k, count: bag.count * v_2))
    }
}

print(numHeld - 1)
