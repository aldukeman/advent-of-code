import Foundation

func array(_ arr: [Int], hasPairSumming sum: Int) -> Bool {
    var elements = Set<Int>()
    for a in arr {
        let needed = sum - a
        if elements.contains(needed) {
            return true
        } else {
            elements.insert(a)
        }
    }
    return false
}

func array(_ arr: [Int], findSubarraySumming sum: Int) -> [Int]? {
    var start = arr.startIndex
    var end = arr.startIndex
    while end != arr.endIndex.advanced(by: 1) {
        let val = arr[start...end].reduce(0, { $0 + $1 })
        if val == sum {
            return [Int](arr[start...end])
        } else if val > sum {
            start = start.advanced(by: 1)
        } else {
            end = end.advanced(by: 1)
        }
    }
    return nil
}

var values = [Int]()
var window = [Int]()
let preamble = 25
for _ in 0..<preamble {
    guard let line = readLine() else { break }
    guard let i = Int(line) else { print(line); fatalError() }
    window.append(i)
    values.append(i)
}

var weakness = 0
while let line = readLine() {
    guard let i = Int(line) else { print(line); fatalError() }
    guard array(window, hasPairSumming: i) else { weakness = i; break }
    window.removeFirst()
    window.append(i)
    values.append(i)
}

guard let weaknessArr = array(values, findSubarraySumming: weakness),
      let min = weaknessArr.min(),
      let max = weaknessArr.max() else { fatalError() }
print(min + max)
