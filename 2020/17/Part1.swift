import Foundation

enum State {
    case active
    case inactive
}

struct World {
    private var world = [Int: [Int: [Int: State]]]()
    
    var numActive: Int {
        var num = 0
        for m in world.values {
            for n in m.values {
                for o in n.values {
                    if o == .active {
                        num += 1
                    }
                }
            }
        }
        return num
    }
    
    subscript(_ i: Int, _ j: Int, _ k: Int) -> State {
        get {
            guard let x = world[i] else { return .inactive }
            guard let y = x[j] else { return .inactive }
            guard let z = y[k] else { return .inactive }
            return z
        }
        set {
            if !world.keys.contains(i) { world[i] = [Int: [Int: State]]() }
            if !world[i]!.keys.contains(j) { world[i]![j] = [Int: State]() }
            switch newValue {
            case .active:
                world[i]![j]![k] = .active
            case .inactive:
                world[i]![j]!.removeValue(forKey: k)
            }
        }
    }
    
    func adjacentTo(_ i: Int, _ j: Int, _ k: Int) -> [(Int, Int, Int)] {
        var ret = [(Int, Int, Int)]()
        for iIter in -1...1 {
            for jIter in -1...1 {
                for kIter in -1...1 {
                    guard iIter != 0 || jIter != 0 || kIter != 0 else { continue }
                    ret.append((i + iIter, j + jIter, k + kIter))
                }
            }
        }
        return ret
    }
    
    private func numNeighborActive(_ i: Int, _ j: Int, _ k: Int) -> Int {
        return self.adjacentTo(i, j, k)
            .map { self[$0,$1,$2] }
            .filter { $0 == .active }
            .count
    }
    
    func cycle() -> World {
        var ret = World()
        
        let iRange = (world.keys.min()! - 1)...(world.keys.max()! + 1)
        
        var minJ = Int.max
        var maxJ = Int.min
        for i in iRange where world[i] != nil {
            minJ = min(minJ, world[i]!.keys.min()!)
            maxJ = max(maxJ, world[i]!.keys.max()!)
        }
        let jRange = (minJ - 1)...(maxJ + 1)
        
        var minK = Int.max
        var maxK = Int.min
        for i in iRange where world[i] != nil {
            for j in jRange where world[i]![j] != nil {
                minK = min(minK, world[i]![j]!.keys.min()!)
                maxK = max(maxK, world[i]![j]!.keys.max()!)
            }
        }
        let kRange = (minK - 1)...(maxK + 1)
        
        for i in iRange {
            for j in jRange {
                for k in kRange {
                    let num = self.numNeighborActive(i, j, k)
                    switch self[i,j,k] {
                    case .active:
                        if num == 2 || num == 3 {
                            ret[i,j,k] = .active
                        }
                    case .inactive:
                        if num == 3 {
                            ret[i,j,k] = .active
                        }
                    }
                }
            }
        }
        
        return ret
    }
}

var world = World()

var lineIdx = 0
while let line = readLine() {
    for (i, c) in line.enumerated() {
        if c == "#" {
            world[0,lineIdx,i] = .active
        }
    }
    lineIdx += 1
}

for _ in 0..<6 {
    world = world.cycle()
}

print(world.numActive)
