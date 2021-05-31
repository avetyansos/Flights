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

extension String {
    func toVisibleDateFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm.SSSZ"
        guard let correctedDate = dateFormatter.date(from: self) else { return nil}
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let correccFormater = DateFormatter()
        correccFormater.dateFormat = "yyyy-MM-dd"
        return correccFormater.string(from: correctedDate)
    }
    
    func toVisibleTimeFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm.SSSZ"
        guard let correctedDate = dateFormatter.date(from: self) else { return nil}
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let correccFormater = DateFormatter()
        correccFormater.dateFormat = "HH:mm"
        return correccFormater.string(from: correctedDate)
    }
}
