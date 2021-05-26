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
    var airportsList:[Station]? {
        didSet {
            self.visibleAirportsList = self.airportsList ?? [Station]()
        }
    }
    var isFromOrigin = true
    var delegate:UserSelectionDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
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
