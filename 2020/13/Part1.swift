import Foundation

guard let line = readLine(), let leaveTime = Int(line) else { fatalError() }
print(leaveTime)

guard let timesLine = readLine() else { fatalError() }
let idStr = timesLine.split(separator: ",")
let ids = idStr.compactMap { $0 != "x" ? Int($0)! : nil }
print(ids)

var earliestBus = ids[0]
var waitTime = leaveTime % earliestBus
for i in ids[0..<ids.count] {
    let iWait = abs((leaveTime % i) - i)
    
    if iWait < waitTime {
        earliestBus = i
        waitTime = iWait
    }
}

print(earliestBus * waitTime)
