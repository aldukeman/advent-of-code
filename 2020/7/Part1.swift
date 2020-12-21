import Foundation

func processLine() -> (holder: String, holdees: Set<String>)? {
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
    
    var holdees = Set<String>()
    for b in bagTokens {
        let c = b.dropFirst().replacingOccurrences(of: " bags", with: "")
        if c != "no other" {
            let tokens = c.split(separator: " ")
            holdees.insert("\(tokens[1]) \(tokens[2])")
        }
    }
    
    return (holder: valColor, holdees: holdees)
}

var holders = [String: Set<String>]()

while let s = processLine() {
    for h in s.holdees {
        var set = holders[h] ?? Set<String>()
        set.insert(s.holder)
        holders[h] = set
    }
}

var processed = Set<String>()
var toProcess = Set<String>(["shiny gold"])

while let p = toProcess.first {
    processed.insert(p)
    toProcess.remove(p)

    guard let held = holders[p] else { continue }
    for h in held {
        guard !processed.contains(h) else { continue }
        toProcess.insert(h)
    }
}

print(processed.count - 1)
