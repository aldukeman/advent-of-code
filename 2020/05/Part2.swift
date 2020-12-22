import Foundation

func processSeat() -> Int? {
    guard let line = readLine() else { return nil }
    
    var rowStr = String(line.prefix(7))
    rowStr = rowStr.replacingOccurrences(of: "F", with: "0")
    rowStr = rowStr.replacingOccurrences(of: "B", with: "1")
    guard let row = Int(rowStr, radix: 2) else { return nil }
    
    var colStr = String(line.suffix(3))
    colStr = colStr.replacingOccurrences(of: "L", with: "0")
    colStr = colStr.replacingOccurrences(of: "R", with: "1")
    guard let col = Int(colStr, radix: 2) else { return nil }
    
    return row * 8 + col
}

var ids = [Int]()
while let id = processSeat() {
    ids += [id]
}

ids.sort()

for i in 1..<ids.count {
    if ids[i] - ids[i - 1] == 2 {
        print(ids[i] - 1)
        break
    }
}
