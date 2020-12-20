import Foundation

var trees = [Int: Set<Int>]()

func processPassport() -> [String]? {
    var fields = [String]()
    while let line = readLine(), !line.isEmpty {
        let lineFields = line.split(separator: " ").map { String($0) }
        fields += lineFields.map { String($0.split(separator: ":").first!) }
    }
    return fields.isEmpty ? nil : fields
}

var passports = [[String]]()
while let passport = processPassport() {
    passports += [passport]
}

let requiredFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
var valid = 0
for p in passports where requiredFields.allSatisfy({ p.contains($0) }) {
    valid += 1
}

print(valid)
