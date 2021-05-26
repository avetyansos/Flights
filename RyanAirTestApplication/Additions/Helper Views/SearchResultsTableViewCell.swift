//
//  SearchResultsTableViewCell.swift
//  RyanAirTestApplication
//
//  Created by Sos Avetyan on 5/26/21.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    @IBOutlet weak var datelLabel: UILabel!
    @IBOutlet weak var flightNumberLabel: UILabel!
    @IBOutlet weak var verticalStack: UIStackView!
    
    var regularFare: [FlightDate]? {
        didSet {
            let horizontalStackView: UIStackView = {
                    let hsv = UIStackView()
                    hsv.axis = .horizontal
                    hsv.alignment = .fill
                    hsv.distribution = .equalSpacing
                    hsv.spacing = 10
                    hsv.translatesAutoresizingMaskIntoConstraints = false

                    return hsv
                }()
            let amountLabel = UILabel()
            amountLabel.text = "Sos"
            horizontalStackView.addSubview(amountLabel)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
