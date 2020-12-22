import Foundation

func processPositions(_ line: String) -> (Int, Int)? {
    let s = line.split(separator: "-")
    guard s.count == 2, let mi = Int(String(s[0])), let ma = Int(String(s[1])) else { return nil }
    return (mi, ma)
}

func processLine(_ line: String) -> Bool {
    let s = line.split(separator: " ")
    guard s.count == 3 else { return false }
    
    guard let m = processPositions(String(s[0])) else { return false }
    let first = m.0
    let second = m.1
    guard let char = s[1].first else { return false }
        
    let password = String(s[2])
    guard password.count >= second else { return false }
    let fIdx = password.index(password.startIndex, offsetBy: first - 1)
    let sIdx = password.index(password.startIndex, offsetBy: second - 1)
    let fChar = password[fIdx]
    let sChar = password[sIdx]
    let out = (fChar == char || sChar == char) && (fChar != sChar)
    return out
}

var numValid = 0
while let line = readLine(strippingNewline: true) {
    if processLine(line) {
        numValid += 1
    }
}

print(numValid)
