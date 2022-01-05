import Cocoa

let name = "PhatNguyen"

for letter in name {
    print("Give me the letter \(letter)")
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]

let letter3 = name[3]

let password = "123456"

password.hasPrefix("123")
password.hasSuffix("456")

let weather = "It's gonna rain"
weather.capitalized
weather.capitalizedWord("n")

let language = ["It", "gonna", "haha"]

weather.containsAny(of: language)

extension String {
    func capitalizedWord(_ word: String) -> String {
        guard self.contains(word) else { return self }
        return self.replacingOccurrences(of: word, with: word.capitalized, options: .literal, range: nil)
    }
    
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ prefix: String) -> String {
        guard self.hasSuffix(prefix) else { return self }
        return String(self.dropLast(prefix.count))
    }
    
    subscript(i: Int) -> String {
        // Return character in location i
        return String(self[index(startIndex, offsetBy: i)])
    }
}


