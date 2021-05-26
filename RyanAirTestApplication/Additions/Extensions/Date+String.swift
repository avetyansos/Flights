//
//  Date+String.swift
//  RyanAirTestApplication
//
//  Created by Sos Avetyan on 5/26/21.
//

import Foundation


extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
