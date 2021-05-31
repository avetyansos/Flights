//
//  Flight.swift
//  RyanAirTestApplication
//
//  Created by Sos Avetyan on 5/25/21.
//

import Foundation


struct Flight: Codable {
    var currency: String?
    var serverTimeUTC: String?
    var currPrecision: Int?
    var trips: [Trip]?
    var termsOfUse: String?
    var routeGroup: String?
    var tripType: String?
    var upgradeType: String?
}

struct Trip: Codable {
    var origin: String?
    var originName: String?
    var destination: String?
    var destinationName: String?
    var routeGroup: String?
    var tripType: String?
    var upgradeType: String?
    var dates: [FlightDate]?
}

struct FlightDate: Codable {
    var dateOut: String?
    var flights: [FlightInfo]?
   
}

struct FlightInfo: Codable {
    var faresLeft : Int?
    var flightKey: String?
    var infantsLeft: String?
    var regularFare: RegularFare?
    var segments: [Segment]?
    var flightNumber: String?
    var timeUTC: [String]?
    var duration: String?
    
}

struct Segment: Codable {
    var segmentNr: Int?
    var origin: String?
    var destination: String?
    var flightNumber: String?
    var time: [String]?
    var timeUTC: [String]?
    var duration: String?
}

struct BusinessFare: Codable {
    var fareKey: String?
    var fareClass: String?
    var fares: [Fare]?
}

struct FlightTime: Codable {
    var time: [String]?
}

struct RegularFare : Codable {
    var fareKey: String?
    var fareClass: String?
    var fares: [Fare]?
}

struct Fare: Codable {
    var amount: Float?
    var count: Int?
    var type: String?
    var hasDiscount: Bool?
    var publishedFare: Float?
    var discountInPercent: Int?
    var hasPromoDiscount: Bool?
    var discountAmount: Int?
    var hasBogof: Bool?
}
