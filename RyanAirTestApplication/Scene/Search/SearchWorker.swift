//
//  SearchWorker.swift
//  RyanAirTestApplication
//

import UIKit


typealias SuccessGetAirports = (_ airports: StationsList ) -> Void
typealias FailureHandler = (_ error: APIError) -> Void

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
    
}
