//
//  SearchPresenter.swift
//  RyanAirTestApplication
//

import UIKit

protocol SearchPresentationLogic {
    func presentStations(response: Search.UseCase.Response)
    func presentError(response: Search.UseCase.Response)
}

class SearchPresenter: SearchPresentationLogic
{
    weak var viewController: SearchDisplayLogic?
    
    
    func presentStations(response: Search.UseCase.Response) {
        var viewModel = Search.UseCase.ViewModel()
        viewModel.stations = response.stations
        viewController?.saveStations(viewModel: viewModel)
    }
    
    func presentError(response: Search.UseCase.Response) {
        var viewModel = Search.UseCase.ViewModel()
        viewModel.errorString = response.errorString
        viewController?.showError(viewModel: viewModel)
    }
}
