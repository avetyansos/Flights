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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var regularFare: FlightDate? {
        didSet {
            self.datelLabel.text = regularFare?.dateOut?.toVisibleDateFormat()
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

extension SearchResultsTableViewCell: UICollectionViewDelegate {
    
}

extension SearchResultsTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return regularFare?.flights?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return regularFare?.flights?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
             let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! TitleCollectionReusableView
            sectionHeader.titleLabel.text = regularFare?.dateOut?.toVisibleTimeFormat()
             return sectionHeader
        } else {
             return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegularFareCollectionViewCell", for: indexPath) as! RegularFareCollectionViewCell
        let flights = regularFare?.flights?[indexPath.row]
        cell.flightNUmberLabel.text = flights?.flightNumber
        cell.priceLabel.text = "\(flights?.regularFare?.fares?.first?.amount)"
        return cell
    }
    
    
}
