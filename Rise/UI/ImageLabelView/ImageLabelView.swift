//
//  ImageLabelSquareView.swift
//  Rise
//
//  Created by Владимир Королев on 21.02.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ImageLabelView: UIView, Statefull, NibLoadable {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!

    // MARK: - Statefull
    struct State {
        let image: UIImage?
        let text: String?
    }
    private(set) var state: State?
    func setState(_ state: State) {
        self.state = state
        imageView.image = state.image
        imageView.contentMode = .scaleAspectFit
        label.text = state.text
    }

    // MARK: - Internal -
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        setupFromNib()
        backgroundColor = .clear
        imageView.tintColor = .white
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
    }
}
