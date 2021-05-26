//
//  SearchInteractor.swift
//  RyanAirTestApplication
//

import UIKit

protocol SearchBusinessLogic {
    func getAeroportsList()
}

protocol SearchDataStore {
    
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore
{
    var presenter: SearchPresentationLogic?
    var worker: SearchWorker?
    //var name: String = ""
    
    func getAeroportsList() {
        var response = Search.UseCase.Response()
        worker = SearchWorker()
        worker?.getAirportsList({ stationsList in
            response.stations = stationsList
            self.presenter?.presentStations(response: response)
        }, { error in
            response.errorString  = error.localizedDescription
            self.presenter?.presentError(response: response)
        })
    }
}
