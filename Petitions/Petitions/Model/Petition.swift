//
//  Petition.swift
//  Petitions
//
//  Created by Phat Nguyen on 24/09/2021.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
