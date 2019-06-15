//
//  CustomDateFormatter.swift
//  Rise
//
//  Created by Vladimir Korolev on 09/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

class CustomDateFormatter: DateFormatter {
    
    override init() {
        super.init()
        
        locale = Locale(identifier: "ru")
        timeStyle = .short
        dateFormat = "HH:mm"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
