//
//  Data.swift
//  DisneyApp
//
//  Created by Sergey Goncharov on 22.12.2023.
//

import Foundation

struct LocalData : Codable {
    var data: [Character]
    var info: Info
}

struct Character : Codable {
    var name: String
    var imageUrl: String?
    var films: [String]
}

struct Info : Codable {
    var totalPages: Int
    var previousPage: String?
    var nextPage: String?
}
