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
        
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        sharedInit()
    }
    
    private func sharedInit() {
        locale = Locale(identifier: "ru")
        timeStyle = .short
        dateFormat = "HH:mm"
    }
}
