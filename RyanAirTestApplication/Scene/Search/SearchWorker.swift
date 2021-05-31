//
//  SearchWorker.swift
//  RyanAirTestApplication
//

import UIKit


typealias SuccessGetAirports = (_ airports: StationsList ) -> Void
typealias FailureHandler = (_ error: APIError) -> Void
typealias SuccessGetSearchRequest = (_ availableFlights: Flight) -> Void

class SearchWorker
{
    
    func getAirportsList(_ success: @escaping SuccessGetAirports, _ failure: @escaping FailureHandler) {
        let request = APIRequest(method: .get, path: AppConstants.getAirportsListTail, baseUrl: AppConstants.baseURL)
        
        APIClient().perform(request) { (response) in
            switch response {
            case .success(let responseValue):
                guard let stations = try? responseValue.decode(to: StationsList.self) else {failure(APIError.decodingFailure); return}
                success(stations.body)
                
            case .failure( let error):
                failure(error.body)
            }
        }
    }
    
    func makeSearchRequest(_ requestItems: Search.UseCase.Request, _ success: @escaping SuccessGetSearchRequest, _ failure: @escaping FailureHandler) {
        let request = APIRequest(method: .get, path: AppConstants.getFlightsTail, baseUrl: AppConstants.searchFlightBaseURL)
        
        request.queryItems = [URLQueryItem(name: "origin", value: requestItems.origin),
                              URLQueryItem(name: "destination", value: requestItems.destination),
                              URLQueryItem(name: "dateout", value: requestItems.dateOut),
                              URLQueryItem(name: "datein", value: requestItems.dateIn),
                              URLQueryItem(name: "flexdaysbeforeout", value: "3"),
                              URLQueryItem(name: "flexdaysout", value: "3"),
                              URLQueryItem(name: "flexdaysbeforein", value: "3"),
                              URLQueryItem(name: "flexdaysin", value: "3"),
                              URLQueryItem(name: "adt", value: requestItems.adult),
                              URLQueryItem(name: "teen", value: requestItems.teen),
                              URLQueryItem(name: "chd", value: requestItems.child),
                              URLQueryItem(name: "inf", value: "0"),
                              URLQueryItem(name: "roundtrip", value: "true"),
                              URLQueryItem(name: "ToUs", value: "AGREED"),
                              URLQueryItem(name: "Disc", value: "0"),]
        
        APIClient().perform(request) { (response) in
            switch response {
            case .success(let responseValue):
                do {
                    let stations = try responseValue.decode(to: Flight.self)
                    success(stations.body)
                } catch {
                    print(error.localizedDescription)
                    failure(APIError.generalErrorWithString(errorString: error.localizedDescription))
                }
                
            case .failure( let error):
                failure(error.body)
            }
        }
    }
}
