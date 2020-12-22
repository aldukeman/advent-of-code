import Foundation

var mask = ""
var mem = [Int: Int]()

func intToBinStringPadded(_ val: Int) -> String {
    return String(String(String(val, radix: 2).reversed()).padding(toLength: mask.count, withPad: "0", startingAt: 0).reversed())
}

func generateAddresses(mask: String, addr: String, derived: String = "") -> [Int] {
    guard let c = mask.first else { return [Int(derived, radix: 2)!] }
    let maskSuffix = String(mask.suffix(from: mask.index(after: mask.startIndex)))
    let addrSuffix = String(addr.suffix(from: addr.index(after: addr.startIndex)))
    
    switch c {
    case "0":
        return generateAddresses(mask: maskSuffix, addr: addrSuffix, derived: derived + addr.prefix(1))
    case "1":
        return generateAddresses(mask: maskSuffix, addr: addrSuffix, derived: derived + "1")
    case "X":
        return generateAddresses(mask: maskSuffix, addr: addrSuffix, derived: derived + "0")
            + generateAddresses(mask: maskSuffix, addr: addrSuffix, derived: derived + "1")
    default:
        fatalError()
    }
}

while let line = readLine() {
    if line.hasPrefix("mask") {
        let tokens = line.split(separator: " ")
        mask = String(tokens[2])
    } else if line.hasPrefix("mem") {
        let dropPrefix = String(line.suffix(from: line.index(after: line.firstIndex(of: "[")!)))
        let memAddrStr = String(dropPrefix.prefix(upTo: dropPrefix.firstIndex(of: "]")!))
        guard let memAddrInt = Int(memAddrStr) else { fatalError() }
        let memAddr = intToBinStringPadded(memAddrInt)
        
        let decValStr = String(line.split(separator: " ").last!)
        guard let val = Int(decValStr) else { fatalError() }
                
        for addr in generateAddresses(mask: mask, addr: memAddr) {
            mem[addr] = val
        }
    } else {
        fatalError()
    }
}

let sum = mem.map { $0.value }.reduce(0) { $0 + $1 }
print(sum)
