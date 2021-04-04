//
//  CollectionPageScrollDelegate.swift
//  Rise
//
//  Created by Владимир Королев on 08.03.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CollectionPageScrollDelegate: NSObject, UICollectionViewDelegate {
    typealias ScrollToPageHandler = (_ page: Int) -> Void

    private let scrollToPageHandler: ScrollToPageHandler

    init(scrollToPageHandler: @escaping ScrollToPageHandler) {
        self.scrollToPageHandler = scrollToPageHandler
        super.init()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let page = Int(ceil(x/w))
        scrollToPageHandler(page)
    }
}
