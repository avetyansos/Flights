//
//  SearchViewController.swift
//  RyanAirTestApplication
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    func saveStations(viewModel : Search.UseCase.ViewModel)
    func showError(viewModel: Search.UseCase.ViewModel)
    func showSearchResults(viewModel: Search.UseCase.ViewModel)
}

class SearchViewController: UIViewController, SearchDisplayLogic
{
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic & SearchDataPassing)?
    @IBOutlet weak var originButton: UIButton!
    @IBOutlet weak var destinationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var adultCountLabel: UILabel!
    @IBOutlet weak var teenCountLabel: UILabel!
    @IBOutlet weak var childCountLabel: UILabel!
    private var stations: [Station]?
    private var selectedOriginStation: Station!
    private var selectedDestinationStation: Station!
    @IBOutlet weak var fromDateField: UITextField!
    @IBOutlet weak var toDateField: UITextField!
    private var selectedDate: Date?
    private let toDatePicker = UIDatePicker()
    private let datePicker = UIDatePicker()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        interactor?.getAeroportsList()
        setDatePickerToDateToField()
    }
    
    func setDatePickerToDateToField() {
        let currentDate = Date()
        var comps = DateComponents()
        comps.year = 0
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            toDatePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        if let date = selectedDate {
            toDatePicker.minimumDate = date
            datePicker.maximumDate = date
        } else {
            datePicker.minimumDate = currentDate
        }
        toDatePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(updateTextFieldDateTo(sender:)), for: .valueChanged)
        toDatePicker.addTarget(self, action: #selector(updateTextFieldDateTo(sender:)), for: .valueChanged)
        self.fromDateField.inputView = datePicker
        self.toDateField.inputView = toDatePicker
    }
    
    @objc func updateTextFieldDateTo(sender: UIDatePicker) {
        guard self.fromDateField.inputView == sender else {
            self.toDateField.text = sender.date.toString()
            self.toDateField.resignFirstResponder()
            return
        }
        self.selectedDate = sender.date
        toDatePicker.minimumDate = sender.date
        self.fromDateField.resignFirstResponder()
        self.fromDateField.text = sender.date.toString()
    }
    
    @IBAction func adultPlusButtonAction(_ sender: UIButton) {
        guard Int(self.adultCountLabel.text!) ?? 0 < 6 else {return}
        var count = Int(self.adultCountLabel.text!) ?? 0
        count += 1
        self.adultCountLabel.text = "\(count)"
        
    }
    @IBAction func adultMinusButtonAction(_ sender: UIButton) {
        guard Int(self.adultCountLabel.text!) ?? 1 > 0 else {return}
        var count = Int(self.adultCountLabel.text!) ?? 1
        count -= 1
        self.adultCountLabel.text = "\(count)"
    }
    @IBAction func teenPlusButtonAction(_ sender: UIButton) {
        guard Int(self.teenCountLabel.text!) ?? 0 < 6 else {return}
        var count = Int(self.teenCountLabel.text!) ?? 0
        count += 1
        self.teenCountLabel.text = "\(count)"
    }
    @IBAction func teenMinusButtonAction(_ sender: UIButton) {
        guard Int(self.teenCountLabel.text!) ?? 1 > 0 else {return}
        var count = Int(self.teenCountLabel.text!) ?? 1
        count -= 1
        self.teenCountLabel.text = "\(count)"
    }
    @IBAction func childPlusButtonAction(_ sender: UIButton) {
        guard Int(self.childCountLabel.text!) ?? 0 < 6 else {return}
        var count = Int(self.childCountLabel.text!) ?? 0
        count += 1
        self.childCountLabel.text = "\(count)"
    }
    @IBAction func childMinusButtonAction(_ sender: UIButton) {
        guard Int(self.childCountLabel.text!) ?? 1 > 0 else {return}
        var count = Int(self.childCountLabel.text!) ?? 1
        count -= 1
        self.childCountLabel.text = "\(count)"
    }
    @IBAction func searchButtonAction(_ sender: UIButton) {
        if Int(childCountLabel.text ?? "0")! > 0 {
            if Int(adultCountLabel.text ?? "0") == 0 {
                self.showErrorAlert(title: "warning", textString: "Child Cannot be without Adult")
            }
        } else if self.adultCountLabel.text == "0", self.teenCountLabel.text == "0"{
            self.showErrorAlert(title: "warning", textString: "Plese select How many people should fly")
        } else if self.selectedOriginStation == nil || self.selectedDestinationStation == nil {
            self.showErrorAlert(title: "warning", textString: "Plese select Airports")
        } else if self.selectedDate == nil {
            self.showErrorAlert(title: "warning", textString: "Plese select Departure date")
        } else {
            var request = Search.UseCase.Request()
            request.origin = self.selectedOriginStation.code
            request.destination = self.selectedDestinationStation.code
            request.dateOut = self.fromDateField.text!
            request.dateIn = self.toDateField.text
            request.adult = self.adultCountLabel.text
            request.child = self.childCountLabel.text
            request.teen = self.teenCountLabel.text
            interactor?.makeSearchRequest(request: request)
        }
    }
    @IBAction func originButtonAction(_ sender: UIButton) {
        router?.navigateToOPtionSelections(stations: self.stations ?? [Station](), isFromOrigin: true, selectedStation: self.selectedOriginStation)
    }
    @IBAction func destinationButtonAction(_ sender: UIButton) {
        router?.navigateToOPtionSelections(stations: self.stations ?? [Station](), isFromOrigin: false, selectedStation: self.selectedDestinationStation)
    }
    
    func saveStations(viewModel : Search.UseCase.ViewModel) {
        self.stations = viewModel.stations?.stations
    }
    
    func showError(viewModel: Search.UseCase.ViewModel) {
        DispatchQueue.main.async {
            self.showErrorAlert(title: "Warning", textString: viewModel.errorString)
        }
    }
    
    func showSearchResults(viewModel: Search.UseCase.ViewModel) {
        DispatchQueue.main.async {
            self.router?.navigateToSearchResults(trips: viewModel.flight.trips)
        }
    }
}

extension SearchViewController : UserSelectionDelegate {
    func userDidSelectedStation(selectedStaion: Station, isOrigin: Bool) {
        if isOrigin {
            self.selectedOriginStation = selectedStaion
            self.originButton.setTitle("\(selectedStaion.name)(\(selectedStaion.code))", for: .normal)
        } else {
            self.selectedDestinationStation = selectedStaion
            self.destinationButton.setTitle("\(selectedStaion.name)(\(selectedStaion.code))", for: .normal)
        }
    }
    
    
}
