//
//  Stations.swift
//  RyanAirTestApplication
//
//  Created by Sos Avetyan on 5/25/21.
//

import Foundation


struct StationsList: Codable {
    var stations : [Station]    
}

struct Station: Codable {
    var alias: [String]
    var alternateName: String?
    var code: String
    var countryAlias: String?
    var countryCode: String
    var countryGroupCode: String
    var countryGroupName: String
    var countryName: String
    var latitude: String
    var longitude: String
    var mobileBoardingPass: Bool
    var name: String
    var notices: String?
    var timeZoneCode: String
    var markets: [Market]
}

struct Market: Codable {
    var code: String
    var aalborg: String?
}
