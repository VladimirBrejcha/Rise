//
//  BannerManager.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import NotificationBannerSwift

struct BannerManager {
    
    public var title: String
    public var style: BannerStyle
    
    public var banner: StatusBarNotificationBanner {
        let banner = StatusBarNotificationBanner(title: title, style: style)
        banner.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return banner
    }
    
}
