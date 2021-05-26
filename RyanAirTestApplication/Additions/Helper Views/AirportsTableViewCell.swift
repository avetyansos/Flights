//
//  AirportsTableViewCell.swift
//  RyanAirTestApplication
//
//  Created by Sos Avetyan on 5/26/21.
//

import UIKit

class AirportsTableViewCell: UITableViewCell {
    @IBOutlet weak var airportsNamelabel: UILabel!
    var station:Station?{
        didSet {
            self.airportsNamelabel.text = "\(self.station?.name ?? "")(\(self.station?.code ?? ""))"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
