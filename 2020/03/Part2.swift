import Foundation

var trees = [Int: Set<Int>]()

func processLine(_ line: String, num: Int) {
    trees[num] = Set<Int>()
    for (i, c) in line.enumerated() where c == "#" {
        trees[num]!.insert(i)
    }
}

func trySlope(down: Int, right: Int) -> Int {
    var line = 0
    var x = 0
    var numTrees = 0
    while line < lines {
        if trees[line]?.contains(x) ?? false {
            numTrees += 1
        }
        
        x += right
        x %= length
        
        line += down
    }
    
    return numTrees
}

var lines = 0
var length = 0
while let line = readLine(strippingNewline: true) {
    processLine(line, num: lines)
    length = line.count
    lines += 1
}

var results = [Int]()
for (d, r) in [(1, 1), (1, 3), (1, 5), (1, 7), (2, 1)] {
    results += [trySlope(down: d, right: r)]
}

print(results.reduce(1, { $0 * $1 }))
