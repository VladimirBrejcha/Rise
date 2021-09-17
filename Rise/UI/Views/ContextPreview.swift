//
//  ContextPreview.swift
//  Rise
//
//  Created by Vladimir Korolev on 22.02.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ContextPreview: UIViewController, Statefull {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let contentSize = CGSize(width: 250, height: 250)
    override var preferredContentSize: CGSize {
        get { contentSize }
        set { log(.warning, "Attempt to change preferredContentSize!") }
    }

    // MARK: - Statefull -
    struct State {
        let image: UIImage?
        let title: String
        let description: String
    }
    private(set) var state: State?
    func setState(_ state: State) {
        imageView.image = state.image
        titleLabel.text = state.title
        descriptionLabel.text = state.description
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)

        view.addConstraints([
            view.heightAnchor.constraint(equalToConstant: 250),
            view.widthAnchor.constraint(equalToConstant: 250),

            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),

            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: 20),

            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
        ])
    }
}
