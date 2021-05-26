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
