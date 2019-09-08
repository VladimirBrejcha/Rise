//
//  CustomContainerView.swift
//  Rise
//
//  Created by Vladimir Korolev on 15/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableContainerView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
}

protocol ContainerViewDelegate: AnyObject {
    func didScroll(item: SegmentedControlCases)
}

class CollectionViewWithSegmentedControl: DesignableContainerView, CustomSegmentedControlDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var segmentedControl: CustomSegmentedControl!
    weak var delegate: ContainerViewDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "cellIdentifier"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSegmentedControl()
    }
    
    // MARK: UISetup Methods
    private func setupSegmentedControl() {
        segmentedControl = CustomSegmentedControl(buttonTitles: [SegmentedControlCases.yesterday.dayDescription,
                                                                 SegmentedControlCases.today.dayDescription,
                                                                 SegmentedControlCases.tomorrow.dayDescription], startingIndex: 1)
        segmentedControl.backgroundColor = .clear
        segmentedControl.delegate = self
        
        addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
//        collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
//        collectionView.contentSize = CGSize(width: self.collectionView.frame.width * 3, height: collectionView.frame.size.height)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CustomCollectionViewCell
//        cell.bounds = collectionView.bounds
////        cell.frame = CGRect(x: collectionView.contentSize, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>)
//        cell.frame.size = collectionView.frame.size

        return cell
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        let x = scrollView.contentOffset.x
        
//        let w = scrollView.bounds.size.width
//        let currentPage = Int(ceil(x/w))
//        switch currentPage {
//        case 0:
//            break
//        case 1:
//            scrollView.contentOffset.x += 10
//        case 2:
//            scrollView.contentOffset.x += 20
//        default:
//            break
//        }

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            let x = scrollView.contentOffset.x
            let w = scrollView.bounds.size.width
            let currentPage = Int(ceil(x/w))
            // Do whatever with currentPage.
        if currentPage > 2 || currentPage < 0{
            return
        }
        segmentedControl.selectedSegmentIndex = currentPage
    }
}

// MARK: CustomContainerViewWithSegmentedControl
extension CollectionViewWithSegmentedControl {
    func segmentedButtonPressed(_ segment: SegmentedControlCases) {
        switch segment {
        case .yesterday:
            collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        case .today:
            collectionView?.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        case .tomorrow:
            collectionView?.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: true)
        }
        delegate?.didScroll(item: segment)
    }
}

extension CollectionViewWithSegmentedControl {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width  = collectionView.bounds.width
        return CGSize(width: width, height: height)
    }
}
