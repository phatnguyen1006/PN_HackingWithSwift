//
//  Petitions.swift
//  Petitions
//
//  Created by Phat Nguyen on 24/09/2021.
//

import Foundation

class Services {
    static func fetchData() -> [Petition] {
        let urlString: String = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
        // fetch data
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // we're OK to parse!
                if let lastData = parse(data) as Petitions? {
                    return lastData.results
                }
            }
        }
        
        return []
    }
    
    static private func parse(_ json: Data) -> Petitions {
        let decoder = JSONDecoder()
        
        let jsonPetitions = try? decoder.decode(Petitions.self, from: json)
        return jsonPetitions!
    }
}
