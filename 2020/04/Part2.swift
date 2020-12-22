import Foundation

struct Passport {
    enum Height {
        case inches(Int)
        case centis(Int)
        
        init?(str: String) {
            if str.count == 5, str.hasSuffix("cm"), let c = Int(String(str.prefix(3))) {
                self = .centis(c)
            } else if str.count == 4, str.hasSuffix("in"), let i = Int(String(str.prefix(2))) {
                self = .inches(i)
            } else {
                return nil
            }
        }
    }
    
    let birthYear: Int
    let issueYear: Int
    let expirationYear: Int
    let height: Height
    let hairColor: String
    let eyeColor: String
    let passportId: String
    
    func isValid() -> Bool {
        guard self.birthYear >= 1920, self.birthYear <= 2002 else { return false }
        guard self.issueYear >= 2010, self.issueYear <= 2020 else { return false }
        guard self.expirationYear >= 2020, self.expirationYear <= 2030 else { return false }
        
        switch self.height {
        case .inches(let i):
            guard i >= 59, i <= 76 else { return false }
        case .centis(let c):
            guard c >= 150, c <= 193 else { return false }
        }
                
        let allowedHair = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
        guard self.hairColor.first == "#",
              self.hairColor.count == 7,
              self.hairColor.suffix(from: self.hairColor.index(after: self.hairColor.startIndex)).allSatisfy({ allowedHair.contains(String($0)) }) else { return false }
        
        let allowedEye = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
        guard allowedEye.contains(self.eyeColor) else { return false }
        
        guard self.passportId.allSatisfy({ $0.isNumber }), self.passportId.count == 9 else { return false }
        
        return true
    }
}

extension String: Error { }

func processPassport() -> Result<Passport?, Error> {
    var fields = [String: String]()
    while let line = readLine(), !line.isEmpty {
        let lineFields = line.split(separator: " ").map { String($0) }
        for field in lineFields {
            let tokens = field.split(separator: ":")
            guard tokens.count == 2 else { return .success(nil) }
            let id = String(tokens.first!)
            let val = String(tokens[1])
            fields[id] = val
        }
    }
    
    guard !fields.isEmpty else { return .failure("no more lines") }
        
    guard let byr = fields["byr"], let b = Int(byr) else { return .success(nil) }
    guard let iyr = fields["iyr"], let i = Int(iyr) else { return .success(nil) }
    guard let eyr = fields["eyr"], let e = Int(eyr) else { return .success(nil) }
    guard let hgt = fields["hgt"], let h = Passport.Height(str: hgt) else { return .success(nil) }
    guard let hcl = fields["hcl"] else { return .success(nil) }
    guard let ecl = fields["ecl"] else { return .success(nil) }
    guard let pid = fields["pid"] else { return .success(nil) }
    
    return .success(Passport(birthYear: b, issueYear: i, expirationYear: e, height: h, hairColor: hcl, eyeColor: ecl, passportId: pid))
}

var cont = true
var passports = [Passport]()
while cont {
    switch processPassport() {
    case .success(let p):
        if let p = p { passports += [p] }
    case .failure:
        cont = false
    }
}

let c = passports.filter { $0.isValid() }.count

print(c)
