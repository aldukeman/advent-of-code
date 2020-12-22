import Foundation

var mask = ""
var mem = [Int: Int]()

while let line = readLine() {
    if line.hasPrefix("mask") {
        let tokens = line.split(separator: " ")
        mask = String(tokens[2])
    } else if line.hasPrefix("mem") {
        let dropPrefix = String(line.suffix(from: line.index(after: line.firstIndex(of: "[")!)))
        let memAddrStr = dropPrefix.prefix(upTo: dropPrefix.firstIndex(of: "]")!)
        guard let memAddr = Int(memAddrStr) else { print(memAddrStr); fatalError() }
        
        let decValStr = String(line.split(separator: " ").last!)
        guard let val = Int(decValStr) else { fatalError() }
        let binValStr = String(String(String(val, radix: 2).reversed()).padding(toLength: mask.count, withPad: "0", startingAt: 0).reversed())
        
        var maskedBinStr = ""
        for (v, m) in zip(binValStr.reversed(), mask.reversed()) {
            switch m {
            case "0":
                maskedBinStr += "0"
            case "1":
                maskedBinStr += "1"
            case "X":
                maskedBinStr += "\(v)"
            default:
                fatalError()
            }
        }
        
        guard let maskedVal = Int(String(maskedBinStr.reversed()), radix: 2) else { print(String(maskedBinStr.reversed())); fatalError() }
        mem[memAddr] = maskedVal
    } else {
        print(line)
        fatalError()
    }
}

let sum = mem.map { $0.value }.reduce(0) { $0 + $1 }
print(sum)
