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

import RealmSwift

// MARK: - LocationElement
class LocationElement: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var name, region: String
    @objc dynamic var lat, lon: Double
}
