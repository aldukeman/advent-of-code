import Foundation

// A basic history...templated for funsies where E must conform to the Hashable protocol
// Hashable allows us to use Set in the allUnique function
class LimitedHistory<E: Hashable> {
  // initialize with empty arr with elements of type E
  private var elements = [E]()
  private var maxSize: Int

  // private(set) means the value can be modified internally, but is read-only
  // outside this class
  private(set) var pushCount = 0

  init(size: Int) {
    self.maxSize = size
  }

  func push(_ elem: E) {
    pushCount += 1
    elements += [elem]
    guard elements.count > maxSize else { return }
    elements.removeFirst()
  }

  func allUnique() -> Bool {
    return Set(elements).count == elements.count
  }
}

let historySize = 14
let hist = LimitedHistory<Character>(size: historySize)
guard let line = readLine() else { exit(-1) }
for c in line.prefix(historySize - 1) {
  hist.push(c)
}

let remaining = line.count - (historySize - 1)
for c in line.suffix(remaining) {
  hist.push(c)
  if hist.allUnique() { break }
}

print(hist.pushCount)
