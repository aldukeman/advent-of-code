import Foundation

var jolts = [Int]()
while let line = readLine() {
    guard let i = Int(line) else { print(line); fatalError() }
    jolts.append(i)
}

jolts.append(0)
let adaptorJolts = jolts.max()! + 3
jolts.append(adaptorJolts)

jolts.sort()

var arrangements = [Int: Int]()
arrangements[0] = 1

for i in 1..<jolts.count {
    let jolt = jolts[i]
    
    var arr = 0
    for j in 1...3 {
        let src = jolt - j
        if src >= 0, let a = arrangements[src]  {
            arr += a
        }
    }
    
    arrangements[jolt] = arr
}

print(arrangements[adaptorJolts]!)
