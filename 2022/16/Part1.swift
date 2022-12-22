import Foundation

class Valve {
  let name: String
  let flow: Int
  let connections: [String]

  init(name: String, flow: Int, connections: String) {
    self.name = name
    self.flow = flow
    self.connections = connections.replacingOccurrences(of: " ", with: "").split(separator: ",").map { String($0) }
  }

  func debug() -> String {
    return "name: \(self.name), flow: \(self.flow), connections: \(self.connections)"
  }
}

class Input {
  let valves: [String: Valve]
  let distanceMap: [String: [String: Int]]

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

  init() {
    var valvesMap = [String: Valve]()

    let capturePattern = "^Valve (?<valve>[A-Z]+) has flow rate=(?<flow>[0-9]+); tunnel(s)? lead(s)? to valve(s)? (?<connections>.*)$"
    let lineRegex = try! NSRegularExpression(pattern: capturePattern, options: [])
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

      
      valvesMap[valveName] = Valve(name: valveName, flow: flow, connections: connections)
    }
    self.valves = valvesMap

    var distMap = [String: [String: Int]]()
    let connMap = valvesMap.mapValues { $0.connections }
    for valve_1 in valvesMap where valve_1.value.flow > 0 || valve_1.key == "AA" {
      distMap[valve_1.key] = [String: Int]()
      for valve_2 in valvesMap where valve_1.key != valve_2.key && valve_2.value.flow > 0 {
        distMap[valve_1.key]![valve_2.key] = Input.breadthFirst(start: valve_1.key, end: valve_2.key, connections: connMap)
      }
    }
    self.distanceMap = distMap
  }
}

struct State {
  let openValves: [Valve]
  let cumFlow: Int
  let location: String

  var flowRate: Int { openValves.map { $0.flow }.reduce(0,+) }

  func openValve(_ valve: Valve) -> State {
    State(openValves: self.openValves + [valve],
          cumFlow: self.cumFlow + flowRate + valve.flow,
          location: self.location)
  }

  func goTo(_ location: String, turns: Int) -> State {
    State(openValves: self.openValves,
          cumFlow: self.cumFlow + flowRate * turns,
          location: location)
  }

  func cumFlow(for turnsRemaining: Int) -> Int {
    self.cumFlow + self.flowRate * (turnsRemaining - 1)
  }

  func isValveOpen(name str: String) -> Bool {
    return self.openValves.contains { $0.name == str }
  }
}

func bestActionScore(turn: Int, maxTurns: Int, env: Input, state: State) -> Int {
  guard turn < maxTurns else { return state.cumFlow(for: maxTurns - turn) }

  var maxScore = state.cumFlow(for: maxTurns - turn)
  let closedValves = env.distanceMap[state.location]!.filter { kvp in !state.isValveOpen(name: kvp.key) }
  for nodeDistPair in closedValves {
    guard nodeDistPair.value < (maxTurns - turn - 1) else { continue }
    let newState = state.goTo(nodeDistPair.key, turns: nodeDistPair.value).openValve(env.valves[nodeDistPair.key]!)
    let score = bestActionScore(turn: turn + nodeDistPair.value + 1, maxTurns: maxTurns, env: env, state: newState)
    maxScore = max(maxScore, score)
  }

  return maxScore
}

let input = Input()
let initialState = State(openValves: [], cumFlow: 0, location: "AA")
let bestScore = bestActionScore(turn: 0, maxTurns: 30, env: input, state: initialState)
print(bestScore)
