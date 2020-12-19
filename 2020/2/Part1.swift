import Foundation

func processMinMax(_ line: String) -> (min: Int, max: Int)? {
    let s = line.split(separator: "-")
    guard s.count == 2, let mi = Int(String(s[0])), let ma = Int(String(s[1])) else { return nil }
    return (min: mi, max: ma)
}

func processLine(_ line: String) -> Bool {
    let s = line.split(separator: " ")
    guard s.count == 3 else { return false }
    
    guard let m = processMinMax(String(s[0])) else { return false }
    let min = m.min
    let max = m.max
    
    guard let char = s[1].first else { return false }
    
    let filtered = String(s[2]).filter { $0 == char }
    return min <= filtered.count && filtered.count <= max
}

var numValid = 0
while let line = readLine(strippingNewline: true) {
    if processLine(line) {
        numValid += 1
    }
}

print(numValid)
