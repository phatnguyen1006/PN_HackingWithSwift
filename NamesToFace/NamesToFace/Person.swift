//
//  Person.swift
//  NamesToFace
//
//  Created by Phat Nguyen on 14/10/2021.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    required init?(coder aDecode: NSCoder) {
        name = aDecode.decodeObject(forKey: "name") as? String ?? ""
        image = aDecode.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
}
