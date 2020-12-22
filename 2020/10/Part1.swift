import Foundation

var jolts = [Int]()
while let line = readLine() {
    guard let i = Int(line) else { print(line); fatalError() }
    jolts.append(i)
}

jolts.append(0)
jolts.append(jolts.max()! + 3)

jolts.sort()

var num_1 = 0
var num_3 = 0
for i in 1..<jolts.count {
    let a = jolts[i]
    let b = jolts[i - 1]
    
    if a - b == 1 {
        num_1 += 1
    } else if a - b == 3 {
        num_3 += 1
    }
}

print(num_1 * num_3)
