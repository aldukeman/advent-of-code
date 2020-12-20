import Foundation

func processGroup() -> Set<Character>? {
    var groupItems = [Set<Character>]()
    while let line = readLine(), !line.isEmpty {
        var indItems = Set<Character>()
        for c in line {
            indItems.insert(c)
        }
        groupItems.append(indItems)
    }
    guard !groupItems.isEmpty else { return nil }
    return groupItems.suffix(from: 1).reduce(groupItems.first!, { $0.intersection($1) })
}

var groups = [Set<Character>]()
while let s = processGroup() {
    groups.append(s)
}

let count = groups.reduce(0, { $0 + $1.count })
print(count)
