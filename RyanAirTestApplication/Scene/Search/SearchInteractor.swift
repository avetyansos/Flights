//
//  SearchInteractor.swift
//  RyanAirTestApplication
//

import UIKit

protocol SearchBusinessLogic {
    func getAeroportsList()
    func makeSearchRequest(request: Search.UseCase.Request)
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
            switch error {
            case .generalErrorWithString(let errorString):
                response.errorString = errorString
            default:
                response.errorString  = error.localizedDescription
            }
            self.presenter?.presentError(response: response)
        })
    }
    
    func makeSearchRequest(request: Search.UseCase.Request) {
        var response = Search.UseCase.Response()
        worker = SearchWorker()
        worker?.makeSearchRequest(request, { flight in
            response.flight = flight
            self.presenter?.presentFlights(response: response)
        }, { error in
            response.errorString = error.localizedDescription
            self.presenter?.presentError(response: response)
        })
    }
}
