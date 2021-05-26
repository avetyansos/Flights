//
//  SearchResultInteractor.swift
//  RyanAirTestApplication
//

import UIKit

protocol SearchResultBusinessLogic {
    
}

protocol SearchResultDataStore {
    
}

class SearchResultInteractor: SearchResultBusinessLogic, SearchResultDataStore
{
    var presenter: SearchResultPresentationLogic?
    var worker: SearchResultWorker?
    //var name: String = ""
    
}
