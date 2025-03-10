//
//  DateFormatter+Extensions.swift
//  LocationTasks
//
//  Created by Abdalla Abdelmagid on 11/10/24.
//

import Foundation

extension DateFormatter {
    static let taskDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
