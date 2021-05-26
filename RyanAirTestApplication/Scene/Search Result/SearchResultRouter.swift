//
//  SearchResultRouter.swift
//  RyanAirTestApplication
//

import UIKit

@objc protocol SearchResultRoutingLogic {
    
}

protocol SearchResultDataPassing {
    var dataStore: SearchResultDataStore? { get }
}

class SearchResultRouter: NSObject, SearchResultRoutingLogic, SearchResultDataPassing
{
    weak var viewController: SearchResultViewController?
    var dataStore: SearchResultDataStore?
    
}
