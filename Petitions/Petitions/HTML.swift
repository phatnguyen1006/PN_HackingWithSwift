//
//  HTML.swift
//  Petitions
//
//  Created by Phat Nguyen on 25/09/2021.
//

import Foundation

func HTML(_ data: Petition) -> String {
    let newHTML = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(data.body)
        </body>
        </html>
        """
    
    return newHTML
}
