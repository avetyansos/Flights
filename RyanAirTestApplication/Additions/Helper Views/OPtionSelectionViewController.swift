//
//  OPtionSelectionViewController.swift
//  RyanAirTestApplication
//
//  Created by Sos Avetyan on 5/26/21.
//

import UIKit

protocol UserSelectionDelegate {
    func userDidSelectedStation(selectedStaion: Station, isOrigin: Bool)
}

class OPtionSelectionViewController: UIViewController {
    private var visibleAirportsList = [Station]()
    @IBOutlet weak var searchTextField: UITextField!
    var selectedStation: Station?
    var airportsList:[Station]? {
        didSet {
            self.visibleAirportsList = self.airportsList ?? [Station]()
            if let station = self.selectedStation {
                self.visibleAirportsList = self.visibleAirportsList.filter({$0.code != station.code})
            }
        }
    }
    var isFromOrigin = true
    var delegate:UserSelectionDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        addTargetOnSearchField()
    }
    
    private func addTargetOnSearchField() {
        self.searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            self.visibleAirportsList = self.visibleAirportsList.filter{
                ($0.countryAlias?.range(of: text, options: .caseInsensitive) != nil)
                    || ($0.countryCode.range(of: text, options: .caseInsensitive) != nil)
                    || ($0.countryName.range(of: text, options: .caseInsensitive) != nil)
                    || ($0.code.range(of: text, options: .caseInsensitive) != nil)
            }
            if self.visibleAirportsList.count == 0 || text.count == 0{
                self.visibleAirportsList = self.airportsList!
            }
            self.tableView.reloadData()
        }
    }
    
    
}


extension OPtionSelectionViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let del = self.delegate else {
            return
        }
        del.userDidSelectedStation(selectedStaion: self.visibleAirportsList[indexPath.row], isOrigin: isFromOrigin)
        self.dismiss(animated: true, completion: nil)
    }
}

extension OPtionSelectionViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.visibleAirportsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirportsTableViewCell", for: indexPath) as! AirportsTableViewCell
        cell.station = self.visibleAirportsList[indexPath.row]
        return cell
    }
    
    
}
