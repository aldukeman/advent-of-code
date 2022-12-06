import Foundation

// A basic stack...templated for funsies
class Stack<E> {
  // initialize with empty arr with elements of type E
  var elements = [E]()

  // Grab the top element, which might not be there, so return 
  // an Optional<E>
  func top() -> E? {
    return elements.last
  }

  // `_ elem` means the call site doesn't have to name the value
  // being passed 
  func push(_ elem: E) {
    elements += [elem]
  }

  func pop() {
    // guard is a reverse if...if the condition is not satisfied, then the else
    // block runs. The else block can execute any code, but it must escape the 
    // current scope, e.g., return from a function, break from a switch, continue 
    // in a loop. It's useful for early exit code such as anaylzing parameter 
    // validity or testing preconditions (as we have here). It's also nice 
    // because it encourages minimal tabbing because there won't be a long tree
    // of nested ifs
    guard elements.count > 0 else { exit(-1) }
    _ = elements.removeLast()
  }

  func reverse() {
    elements.reverse()
  }
}

// grab the initial state
var initialState = [String]()
var line = readLine()! // force unwrap the Optional<String> returned by readLine
while !line.contains("1") {
  initialState += [line]
  line = readLine()!
}
let numStacks = line.split(separator: " ")
  .compactMap { Int($0) }
  .max()!

// parse the initial stack to data structures
var stacks = [Stack<Character>]()
for _ in 1...numStacks {
  stacks += [Stack<Character>()]
}
for line in initialState.reversed() { // we need to read and insert from bottom to top
  // The where clause checks a conditional before running a loop iteration. It's
  // equivalent to having a single if/guard statement in the loop
  for (idx, c) in line.enumerated() where c.isLetter {
    let stackIdx: Int = idx / 4
    stacks[stackIdx].push(c)
  }
}

// discard the empty line
_ = readLine()

// read the move commands
while let line = readLine() {
  let nums = line.split(separator: " ") // get the tokens
    .compactMap { Int($0) } // try parsing to int and keep just those that succeed
  assert(nums.count == 3)

  // get the nums and remember to 0-index
  let count = nums[0]
  let from = nums[1] - 1
  let to = nums[2] - 1

  // Do the transfer, repeat the loop `count` times, the `_` indicates we don't care 
  // what iteration we are on
  for _ in 1...count {
    stacks[to].push(stacks[from].top()!)
    stacks[from].pop()
  }
}

let answer = stacks
  .compactMap { $0.top() } // Get the top character of each stack
  .map { String($0) } // Convert to String
  .joined(separator: "") // Make the answer
print(answer)
