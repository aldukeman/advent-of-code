import Foundation

class Monkey {
  var items: [Int]
  var update: (Int) -> Int
  var test: (Int) -> Bool
  var nextMonkey: (Bool) -> Int
  var itemsInspected = 0

  init(items: [Int], update: @escaping (Int) -> Int, test: @escaping (Int) -> Bool, nextMonkey: @escaping (Bool) -> Int) {
    self.items = items
    self.update = update
    self.test = test
    self.nextMonkey = nextMonkey
  }

  func takeTurn() -> [Int: [Int]] {
    var thrownItems = [Int: [Int]]()
    self.itemsInspected += self.items.count

    for item in self.items {
      let newItem: Int = self.update(item) / 3
      let throwTo = self.nextMonkey(self.test(newItem))
      var arr = thrownItems[throwTo] ?? [Int]()
      arr += [newItem]
      thrownItems[throwTo] = arr
    }

    self.items = []
    
    return thrownItems
  }

  func addItems(_ items: [Int]) {
    self.items += items
  }
}

let monkeys = [
  Monkey(
    items: [99, 67, 92, 61, 83, 64, 98],
    update: { $0 * 17 },
    test: { $0 % 3 == 0 },
    nextMonkey: { $0 ? 4 : 2 }
  ),
  Monkey(
    items: [78, 74, 88, 89, 50],
    update: { $0 * 11 },
    test: { $0 % 5 == 0 },
    nextMonkey: { $0 ? 3 : 5 }
  ),
  Monkey(
    items: [98, 91],
    update: { $0 + 4 },
    test: { $0 % 2 == 0 },
    nextMonkey: { $0 ? 6 : 4 }
  ),
  Monkey(
    items: [59, 72, 94, 91, 79, 88, 94, 51],
    update: { $0 * $0 },
    test: { $0 % 13 == 0 },
    nextMonkey: { $0 ? 0 : 5 }
  ),
  Monkey(
    items: [95, 72, 78],
    update: { $0 + 7 },
    test: { $0 % 11 == 0 },
    nextMonkey: { $0 ? 7 : 6 }
  ),
  Monkey(
    items: [76],
    update: { $0 + 8 },
    test: { $0 % 17 == 0 },
    nextMonkey: { $0 ? 0 : 2 }
  ),
  Monkey(
    items: [69, 60, 53, 89, 71, 88],
    update: { $0 + 5 },
    test: { $0 % 19 == 0 },
    nextMonkey: { $0 ? 7 : 1 }
  ),
  Monkey(
    items: [72, 54, 63, 80],
    update: { $0 + 3 },
    test: { $0 % 7 == 0 },
    nextMonkey: { $0 ? 1 : 3 }
  ),
]

for _ in 0..<20 {
  for i in 0..<monkeys.count {
    let thrown = monkeys[i].takeTurn()
    for kvp in thrown {
      monkeys[kvp.key].addItems(kvp.value)
    }
  }
}

print(monkeys.map { $0.itemsInspected }.sorted(by: >).prefix(2).reduce(1,*))
