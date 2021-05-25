//
//  SearchInteractor.swift
//  RyanAirTestApplication
//

import UIKit

protocol SearchBusinessLogic {
    
}

protocol SearchDataStore {
    
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore
{
    var presenter: SearchPresentationLogic?
    var worker: SearchWorker?
    //var name: String = ""
    
}
