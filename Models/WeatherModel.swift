//
//  WeatherModel.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 11/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weather = try? newJSONDecoder().decode(Weather.self, from: jsonData)

import Foundation

// MARK: - Weather
struct Weather: Codable {
    var currently: Currently
    let hourly: Hourly
    let daily: Daily
    let alerts: [Alert]?
}

// MARK: - Currently
struct Currently: Codable {
    let time: Int
    let icon: Icon
    let summary: String
    var temperature: Double
    let precipProbability: Double
}

// MARK: - Alert
struct Alert: Codable {
    let title: String
    //let regions: [String]
    let description: String
}

enum Icon: String, Codable {
    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    case cloudy = "cloudy"
    case rain = "rain"
    case snow = "snow"
    case sleet = "sleet"
    case wind = "wind"
    case fog = "fog"
}

// MARK: - Daily
struct Daily: Codable {
    let summary: String
    //let icon: Icon
    let data: [DailyDatum]
}

// MARK: - DailyDatum
struct DailyDatum: Codable {
    let time: Int
    let icon: Icon
    let temperatureHigh: Double
    let temperatureLow: Double
}

// MARK: - Hourly
struct Hourly: Codable {
    //let icon: Icon
    let data: [Currently]
}

