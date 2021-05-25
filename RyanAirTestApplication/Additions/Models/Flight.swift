//
//  Flight.swift
//  RyanAirTestApplication
//
//  Created by Sos Avetyan on 5/25/21.
//

import Foundation


struct Flight: Codable {
    var currency: String
    var serverTimeUTC: String
    var currPrecision: Int
    var trips: [Trip]
}

struct Trip: Codable {
    var origin: String
    var destination: String
    var dates: [Date]
}

struct Date: Codable {
    var dateOut: String
    var flights: [FlightTime]
    var regularFare: RegularFare
    var faresLeft: Int
    var timeUTC : [String]
    var duration: String
    var flightNumber: String
    var infantsLeft: Int
    var flightKey: String
    var businessFare: BusinessFare
}

struct BusinessFare: Codable {
    var fareKey: String
    var fareClass: String
    var fares: [Fare]
}

struct FlightTime: Codable {
    var time: [String]?
}

struct RegularFare : Codable {
    var fareKey: String
    var fareClass: String
    var fares: [Fare]
}

struct Fare: Codable {
    var amount: Double
    var count: String
    var type: String
    var hasDiscount: Bool
    var publishedFare: Double
}
