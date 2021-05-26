//
//  SearchRouter.swift
//  RyanAirTestApplication
//

import UIKit

 protocol SearchRoutingLogic {
    func navigateToOPtionSelections(stations: [Station], isFromOrigin: Bool, selectedStation : Station?)
}

protocol SearchDataPassing {
    var dataStore: SearchDataStore? { get }
}

class SearchRouter: NSObject, SearchRoutingLogic, SearchDataPassing
{
    weak var viewController: SearchViewController?
    var dataStore: SearchDataStore?
    
    func navigateToOPtionSelections(stations: [Station], isFromOrigin: Bool, selectedStation : Station?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyboard.instantiateViewController(identifier: "OPtionSelectionViewController") as! OPtionSelectionViewController
        destination.delegate = viewController
        destination.selectedStation = selectedStation
        destination.airportsList = stations
        destination.isFromOrigin = isFromOrigin
        viewController?.navigationController?.present(destination, animated: true, completion: nil)
    }
    
}
