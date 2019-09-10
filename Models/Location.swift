//
//  Location.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 9/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let location = try? newJSONDecoder().decode(Location.self, from: jsonData)

// MARK: - LocationElement
struct LocationElement: Codable {
    let id: Int
    let name, region: String
    let country: Country
    let lat, lon: Double
    let url: String
}

enum Country: String, Codable {
    case bangladesh = "Bangladesh"
}

typealias Location = [LocationElement]
