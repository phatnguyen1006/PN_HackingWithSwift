import Cocoa

let name = "PhatNguyen"

for letter in name {
    print("Give me the letter \(letter)")
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]


extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter3 = name[3]
