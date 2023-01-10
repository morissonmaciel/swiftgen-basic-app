//
//  String+Extensions.swift
//  PaperedApp
//
//  Created by Morisson Marcel on 09/01/23.
//

import Foundation

extension String {
    var dateISO8610: Date? {
        let formatter  = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        guard let date = formatter.date(from: self) else {
            return nil
        }
        
        return date
    }
}
