//
//  DateFormatter+Extensions.swift
//  WeatherApp
//
//  Created by Brandt Dary on 1/30/23.
//

import Foundation

extension DateFormatter {
    
    static let utcDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
}
