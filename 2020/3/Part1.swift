import Foundation

var trees = [Int: Set<Int>]()

func processLine(_ line: String, num: Int) {
    trees[num] = Set<Int>()
    for (i, c) in line.enumerated() where c == "#" {
        trees[num]!.insert(i)
    }
}

var lines = 0
var length = 0
while let line = readLine(strippingNewline: true) {
    processLine(line, num: lines)
    length = line.count
    lines += 1
}

let down = 1
let right = 3

var line = 0
var x = 0
var y = 0
var numTrees = 0
while line < lines {
    if trees[line]?.contains(x) ?? false {
        numTrees += 1
    }
    
    x += right
    x %= length
    
    line += 1
}

print(numTrees)
