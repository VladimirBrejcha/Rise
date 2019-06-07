//
//  BannerManager.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class BannerManager {
    
    // MARK: Properties
    private var banner: StatusBarNotificationBanner!
    
    // MARK: Methods
    func showBanner(title: String, style: BannerStyle) {
        
        banner = StatusBarNotificationBanner(title: title, style: style)
        
        banner.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        banner.show()
    }
}
