//
//  PersonalTimeOutputModel.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct PersonalTimeConverter {
    
    private var dateFormatter = DateFormatter()
    
    func convertData(string input: String) -> Date {
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ru")
        guard let convertedData = dateFormatter.date(from: input) else { fatalError("Could'nt convert String to Date") }
        return convertedData
    }
}
