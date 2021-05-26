//
//  UIViewController + Allert.swift
//  RyanAirTestApplication
//
//  Created by Sos Avetyan on 5/26/21.
//

import UIKit


extension UIViewController {
    func showErrorAlert(title: String?, textString: String) {
        let alertController = UIAlertController(title: title ?? "", message: textString, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}


