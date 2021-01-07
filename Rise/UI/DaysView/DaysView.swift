//
//  DaysView.swift
//  Rise
//
//  Created by Владимир Королев on 08/09/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import SelectableStackView

final class DaysView:
    DesignableContainerView,
    SelectableStackViewDelegate,
    NibLoadable
{
    @IBOutlet private weak var segmentedControl: SelectableStackView!
    @IBOutlet private weak var collectionView: DaysCollectionView!
    var dataSource: DaysCollectionView.DataSource {
        collectionView.diffableDataSource
    }
    
    private var shouldCenter = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        setupFromNib()
        collectionView.didScrollToPageHandler = { [weak self] page in
            if page >= 0 && page <= 2 {
                self?.segmentedControl.select(true, at: page)
            }
        }
        segmentedControl.delegate = self
        segmentedControl.select(true, at: 1)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if shouldCenter {
            collectionView.setContentOffset(CGPoint(x: collectionView.bounds.width, y: 0), animated: false)
            shouldCenter = false
        }
    }
    
    // MARK: - SelectableStackViewDelegate -
    func didSelect(_ select: Bool, at index: Index, on selectableStackView: SelectableStackView) {
        if select {
            collectionView.setContentOffset(CGPoint(x: Int(collectionView.bounds.width) * index, y: 0), animated: true)
        }
    }
}
