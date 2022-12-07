import Foundation

class Node {
  private(set) var parent: Node?
  private(set) var children = [Node]()
  let name: String
  private(set) var size = 0

  var isDirectory: Bool { !self.children.isEmpty }

  init(_ name: String) {
    self.name = name
  }

  func addChild(_ node: Node) {
    node.parent = self
    self.children += [node]
  }

  func debug(tabs: Int = 0) {
    let nameStr = name + " (size=\(self.isDirectory ? self.recursiveSize() : self.size))"
    print([String](repeating: "  ", count: tabs).joined(separator: "") + "- " + nameStr)
    for child in self.children {
      child.debug(tabs: tabs + 1)
    }
  }

  func fullyQualifiedName() -> String {
    guard let parent = self.parent else { return "/" }
    let parentName = parent.fullyQualifiedName()
    return parentName + name + (children.isEmpty ? "" : "/")
  }

  func setSize(_ size: Int) {
    self.size = size
  }

  func recursiveSize() -> Int {
    if children.isEmpty {
      return size
    } else {
      return children.map { $0.recursiveSize() }.reduce(0,+)
    }
  }
}

enum Command {
  enum Destination {
    case root
    case up
    case dir(String)
  }

  case cd(Destination)
  case ls

  init?(_ cmd: String) {
    let tokens = cmd.split(separator: " ")
    guard tokens.count >= 2 else {
      print("Invalid tokens for command: \(cmd)")
      return nil
    }
    guard tokens[0] == "$" else {
      print("Invalid command start token: \(tokens[0])")
      return nil
    }

    if tokens[1] == "cd" {
      guard tokens.count == 3 else {
        print("Invalid token count: \(tokens.count), \(tokens)")
        return nil
      }
      if tokens[2] == "/" {
        self = .cd(.root)
      } else if tokens[2] == ".." {
        self = .cd(.up)
      } else {
        self = .cd(.dir(String(tokens[2])))
      }
    } else if tokens[1] == "ls" {
      self = .ls
    } else {
      print("Unknown command: \(cmd)")
      return nil
    }
  }

  func debug() {
    switch self {
      case .cd(.root): print("cd /")
      case .cd(.up): print("cd ..")
      case .cd(.dir(let name)): print("cd \(name)")
      case .ls: print("ls")
    }
  }
}

class Terminal {
  private var root: Node!
  private var pwd: Node!
  private var nextLine: String?

  func processInput() -> Node {
    self.root = Node("root")
    self.pwd = self.root
    self.nextLine = readLine()

    while let line = self.nextLine, let cmd = Command(line) {
      switch cmd {
      case .cd(let dest): self.processCd(dest)
      case .ls: self.processLs()
      }
    }

    return root
  }

  private func processCd(_ dest: Command.Destination) {
    switch dest {
    case .root:
      self.pwd = self.root
    case .up:
      guard let p = self.pwd.parent else {
        print("No parent")
        exit(-1)
      }
      self.pwd = p
    case .dir(let name):
      guard let c = self.pwd.children.first(where: { $0.name == name }) else {
        print("Invalid cd destination: \(name)")
        exit(-1)
      }
      self.pwd = c
    }
  
    self.nextLine = readLine()
  }
  
  private func processLs() {
    self.nextLine = readLine()

    while let line = self.nextLine, line.first != "$" {
      let tokens = line.split(separator: " ")
      guard tokens.count == 2 else {
        print("Bad line: \(line)")
        exit(-1)
      }

      if tokens.first == "dir" {
        self.pwd.addChild(Node(String(tokens[1])))
      } else if let sizeStr = tokens.first, let size = Int(sizeStr) {
        let name = String(tokens[1])
        let newChild = Node(name)
        newChild.setSize(size)
        self.pwd.addChild(newChild)
      }

      self.nextLine = readLine()
    }
  }
}

func doProblem(_ node: Node) -> Int {
  guard node.isDirectory else { return 0 }

  let childrenRecursion = node.children
    .map { doProblem($0) }
    .reduce(0,+)
  
  let nodeSize = node.recursiveSize()
  if nodeSize <= 100000 {
    return childrenRecursion + nodeSize
  } else {
    return childrenRecursion
  }
}

let root = Terminal().processInput()
print(doProblem(root))
