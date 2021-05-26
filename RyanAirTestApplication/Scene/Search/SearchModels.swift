//
//  SearchModels.swift
//  RyanAirTestApplication
//

import UIKit

enum Search
{
    
    enum UseCase
    {
        struct Request
        {
            var origin: String!
            var destination: String!
            var dateOut: String!
            var dateIn: String?
            var adult: String!
            var teen: String!
            var child: String!
        }
        struct Response
        {
            var stations: StationsList?
            var errorString = ""
        }
        struct ViewModel
        {
            var stations: StationsList?
            var errorString = ""
        }
    }
}
