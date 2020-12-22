import Foundation

func processGroup() -> Set<Character>? {
    var items = Set<Character>()
    while let line = readLine(), !line.isEmpty {
        for c in line {
            items.insert(c)
        }
    }
    guard !items.isEmpty else { return nil }
    return items
}

var groups = [Set<Character>]()
while let s = processGroup() {
    groups.append(s)
}

let count = groups.reduce(0, { $0 + $1.count })
print(count)
