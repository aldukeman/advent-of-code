import Foundation

class Valve: Hashable {
  let name: String
  let flow: Int

  init(name: String, flow: Int) {
    self.name = name
    self.flow = flow
  }

  func debug() -> String {
    return "name: \(self.name), flow: \(self.flow)"
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.name)
  }

  static func ==(lhs: Valve, rhs: Valve) -> Bool {
    return lhs.name == rhs.name
  }
}

class Input {
  let valves: [Valve]
  let distanceMap: [Valve: [Valve: Int]]
  let maxTurns: Int

  private static func breadthFirst(start: String, end: String, connections: [String: [String]]) -> Int {
    guard start != end else { return 0 }

    struct SearchNode: Hashable {
      let str: String
      let dist: Int

      func hash(into hasher: inout Hasher) {
        hasher.combine(self.str)
      }
    }
    
    var frontier = [SearchNode(str: start, dist: 0)]
    var visited = Set<String>()
  
    while let next = frontier.first {
      guard next.str != end else { return next.dist }
      frontier.removeFirst()
      visited.insert(next.str)

      for conn in connections[next.str]! where !visited.contains(conn) {
        frontier += [SearchNode(str: conn, dist: next.dist + 1)]
      }
    }

    return Int.max
  }

  init(maxTurns: Int) {
    self.maxTurns = maxTurns

    var valvesMap = [String: Valve]()

    let capturePattern = "^Valve (?<valve>[A-Z]+) has flow rate=(?<flow>[0-9]+); tunnel(s)? lead(s)? to valve(s)? (?<connections>.*)$"
    let lineRegex = try! NSRegularExpression(pattern: capturePattern, options: [])
    var connectionsMap = [String: [String]]()
    while let line = readLine() {
      let range = NSRange(line.startIndex..., in: line)
      let matches = lineRegex.matches(in: line, options: [], range: range)
      guard let match = matches.first else { exit(-1) }

      let valveRange = match.range(withName: "valve")
      let flowRange = match.range(withName: "flow")
      let connectionsRange = match.range(withName: "connections")

      guard let valveRangeInLine = Range(valveRange, in: line) else { exit(-1) }
      guard let flowRangeInLine = Range(flowRange, in: line) else { exit(-1) }
      guard let connectionsRangeInLine = Range(connectionsRange, in: line) else { exit(-1) }

      let valveName = String(line[valveRangeInLine])
      guard let flow = Int(String(line[flowRangeInLine])) else { exit(-1) }
      let connections = String(line[connectionsRangeInLine])
      connectionsMap[valveName] = connections
        .replacingOccurrences(of: " ", with: "")
        .split(separator: ",")
        .map { String($0) }

      valvesMap[valveName] = Valve(name: valveName, flow: flow)
    }
    self.valves = valvesMap.map { $0.value }

    var distMap = [Valve: [Valve: Int]]()
    for valve_1 in valvesMap where valve_1.value.flow > 0 || valve_1.key == "AA" {
      distMap[valve_1.value] = [Valve: Int]()
      for valve_2 in valvesMap where valve_1.key != valve_2.key && valve_2.value.flow > 0 {
        distMap[valve_1.value]![valve_2.value] = Input.breadthFirst(start: valve_1.key,
                                                                end: valve_2.key,
                                                                connections: connectionsMap)
      }
    }
    self.distanceMap = distMap
  }
}

struct State {
  struct Actor {
    let turn: Int
    let location: Valve
  
    func openValve(_ valve: Valve, dist: Int) -> Actor {
      Actor(
        turn: self.turn + dist + 1,
        location: valve
      )
    }
  }

  let openValves: [Valve: Int]
  let closedValves: [Valve]
  let me: Actor
  let elephant: Actor

  init(start: Valve, closedValves: [Valve]) {
    self.openValves = [:]
    self.closedValves = closedValves
    self.me = Actor(turn: 0, location: start)
    self.elephant = Actor(turn: 0, location: start)
  }

  private init(openValves: [Valve: Int], closedValves: [Valve], me: Actor, elephant: Actor) {
    self.openValves = openValves
    self.closedValves = closedValves
    self.me = me
    self.elephant = elephant
  }

  func meOpen(idx: Int, dist: Int) -> State {
    let valve = self.closedValves[idx]
    let newMe = self.me.openValve(valve, dist: dist)
    var newClosed = self.closedValves
    newClosed.remove(at: idx)
    return State(
      openValves: self.openValves.merging([valve: newMe.turn]) { $1 },
      closedValves: newClosed,
      me: newMe,
      elephant: self.elephant
    )
  }

  func eleOpen(idx: Int, dist: Int) -> State {
    let valve = self.closedValves[idx]
    let newElephant = self.elephant.openValve(valve, dist: dist)
    var newClosed = self.closedValves
    newClosed.remove(at: idx)
    return State(
      openValves: self.openValves.merging([valve: newElephant.turn]) { $1 },
      closedValves: newClosed,
      me: self.me,
      elephant: newElephant
    )
  }

  func flow(by turn: Int) -> Int {
    self.openValves.map { $0.key.flow * (turn - $0.value) }.reduce(0,+)
  }
}

struct Candidate {
  let last: Valve
  let path: Set<Valve>
  let turns: Int
  let flow: Int

  func append(_ valve: Valve, dist: Int, max: Int) -> Candidate {
    Candidate(
      last: valve,
      path: self.path.union([valve]),
      turns: self.turns + dist + 1,
      flow: self.flow + valve.flow * (max - (self.turns + dist + 1))
    )
  }

  func debug() {
    print(path.map { $0.name }.joined(separator: " -> "))
  }
}

func allCandidates(env: Input, from candidate: Candidate, remaining: [Valve], maxTurns: Int) -> [Candidate] {
  guard candidate.turns < maxTurns else { return [] }
  var candidates = [candidate]
  guard !remaining.isEmpty else { return candidates }

  let distMapForLast = env.distanceMap[candidate.last]!
  for (i, v) in remaining.enumerated() {
    let dist = distMapForLast[v]!
    let next = candidate.append(v, dist: dist, max: maxTurns)
    var newRemaining = remaining
    newRemaining.remove(at: i)
    candidates += allCandidates(env: env, from: next, remaining: newRemaining, maxTurns: maxTurns)
  }

  return candidates
}

let input = Input(maxTurns: 26)
let initial = Candidate(
  last: input.valves.first { $0.name == "AA" }!,
  path: [],
  turns: 0,
  flow: 0
)
let remaining = input
  .valves
  .filter { $0.flow > 0 }
let candidates = allCandidates(env: input, from: initial, remaining: remaining, maxTurns: input.maxTurns)

var maxScore = 0
for i in 0..<candidates.count {
  for j in i..<candidates.count where candidates[i].path.isDisjoint(with: candidates[j].path) {
    maxScore = max(maxScore, candidates[i].flow + candidates[j].flow)
  }
}
print(maxScore)
