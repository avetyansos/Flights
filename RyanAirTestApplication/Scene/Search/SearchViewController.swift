//
//  SearchViewController.swift
//  RyanAirTestApplication
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    func saveStations(viewModel : Search.UseCase.ViewModel)
    func showError(viewModel: Search.UseCase.ViewModel)
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
    private var selectedStation: Station?
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
        let calerndar = NSCalendar(calendarIdentifier: .gregorian)
        let currentDate = Date()
        var comps = DateComponents()
        comps.year = 0
        let maxDate = calerndar?.date(byAdding: comps, to: currentDate, options: [])
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            toDatePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        if let date = selectedDate {
            toDatePicker.minimumDate = date
            datePicker.maximumDate = date
        } else {
            toDatePicker.maximumDate = maxDate
            datePicker.maximumDate = maxDate
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
        
    }
    @IBAction func originButtonAction(_ sender: UIButton) {
        router?.navigateToOPtionSelections(stations: self.stations ?? [Station](), isFromOrigin: true)
    }
    @IBAction func destinationButtonAction(_ sender: UIButton) {
        router?.navigateToOPtionSelections(stations: self.stations ?? [Station](), isFromOrigin: false)
    }
    
    func saveStations(viewModel : Search.UseCase.ViewModel) {
        self.stations = viewModel.stations?.stations
    }
    
    func showError(viewModel: Search.UseCase.ViewModel) {
        print(viewModel.errorString)
    }
}

extension SearchViewController : UserSelectionDelegate {
    func userDidSelectedStation(selectedStaion: Station, isOrigin: Bool) {
        if isOrigin {
            self.originButton.setTitle("\(selectedStaion.name)(\(selectedStaion.code))", for: .normal)
        } else {
            self.destinationButton.setTitle("\(selectedStaion.name)(\(selectedStaion.code))", for: .normal)
        }
    }
    
    
}
