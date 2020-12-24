import Foundation

enum State {
    case active
    case inactive
}

struct World {
    private var world = [Int: [Int: [Int: [Int: State]]]]()
    
    var numActive: Int {
        var num = 0
        for m in world.values {
            for n in m.values {
                for o in n.values {
                    for p in o.values {
                        if p == .active {
                            num += 1
                        }
                    }
                }
            }
        }
        return num
    }
    
    subscript(_ i: Int, _ j: Int, _ k: Int, _ l: Int) -> State {
        get {
            guard let x = world[i] else { return .inactive }
            guard let y = x[j] else { return .inactive }
            guard let z = y[k] else { return .inactive }
            guard let a = z[l] else { return .inactive }
            return a
        }
        set {
            if !world.keys.contains(i) { world[i] = [Int: [Int: [Int: State]]]() }
            if !world[i]!.keys.contains(j) { world[i]![j] = [Int: [Int: State]]() }
            if !world[i]![j]!.keys.contains(k) { world[i]![j]![k] = [Int: State]() }
            switch newValue {
            case .active:
                world[i]![j]![k]![l] = .active
            case .inactive:
                world[i]![j]![k]!.removeValue(forKey: l)
            }
        }
    }
    
    func adjacentTo(_ i: Int, _ j: Int, _ k: Int, _ l: Int) -> [(Int, Int, Int, Int)] {
        var ret = [(Int, Int, Int, Int)]()
        for iIter in -1...1 {
            for jIter in -1...1 {
                for kIter in -1...1 {
                    for lIter in -1...1 {
                        guard iIter != 0 || jIter != 0 || kIter != 0 || lIter != 0 else { continue }
                        ret.append((i + iIter, j + jIter, k + kIter, l + lIter))
                    }
                }
            }
        }
        return ret
    }
    
    private func numNeighborActive(_ i: Int, _ j: Int, _ k: Int, _ l: Int) -> Int {
        return self.adjacentTo(i, j, k, l)
            .map { self[$0,$1,$2,$3] }
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
        
        var minL = Int.max
        var maxL = Int.min
        for i in iRange where world[i] != nil {
            for j in jRange where world[i]![j] != nil {
                for k in kRange where world[i]![j]![k] != nil {
                    minL = min(minL, world[i]![j]![k]!.keys.min()!)
                    maxL = max(maxL, world[i]![j]![k]!.keys.max()!)
                }
            }
        }
        let lRange = (minL - 1)...(maxL + 1)
        
        for i in iRange {
            for j in jRange {
                for k in kRange {
                    for l in lRange {
                        let num = self.numNeighborActive(i, j, k, l)
                        switch self[i,j,k,l] {
                        case .active:
                            if num == 2 || num == 3 {
                                ret[i,j,k,l] = .active
                            }
                        case .inactive:
                            if num == 3 {
                                ret[i,j,k,l] = .active
                            }
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
            world[0,0,lineIdx,i] = .active
        }
    }
    lineIdx += 1
}

for _ in 0..<6 {
    world = world.cycle()
}

print(world.numActive)
