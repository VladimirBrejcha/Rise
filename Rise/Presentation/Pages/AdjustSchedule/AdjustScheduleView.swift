//  
//  AdjustScheduleView.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Localization
import UILibrary

final class AdjustScheduleView: UIView {
  
  private let closeHandler: () -> Void
  private let saveHandler: () -> Void
  private let dateChangedHandler: (Date) -> Void
  private let descriptionText: String
  
  // MARK: - Subviews
  
  private lazy var titleView: UIView = Title.make(
    title: Text.adjustSchedule,
    closeButton: .default { [weak self] in
      self?.closeHandler()
    }
  )
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "bed.double.circle.fill")
      imageView.tintColor = Asset.Colors.white.color
    return imageView
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.applyStyle(.mediumSizedBody)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.text = descriptionText
    return label
  }()
  
  private lazy var datePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.datePickerMode = .time
    datePicker.applyStyle(.usual)
    datePicker.addTarget(
      self,
      action: #selector(datePickerValueChanged(_:)),
      for: .valueChanged
    )
    return datePicker
  }()
  
  private lazy var saveButton: Button = {
    let button = Button()
    button.setTitle(Text.save, for: .normal)
    button.onTouchUp = { [weak self] in
      self?.saveHandler()
    }
    return button
  }()
  
  // MARK: - LifeCycle
  
  init(
    closeHandler: @escaping () -> Void,
    saveHandler: @escaping () -> Void,
    descriptionText: String,
    initialDate: Date,
    dateChangedHandler: @escaping (Date) -> Void
  ) {
    self.closeHandler = closeHandler
    self.saveHandler = saveHandler
    self.dateChangedHandler = dateChangedHandler
    self.descriptionText = descriptionText
    super.init(frame: .zero)
    datePicker.setDate(initialDate, animated: false)
    setupViews()
    setupLayout()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("This class does not support NSCoder")
  }
  
  private func setupViews() {
    addBackgroundView()
    addScreenTitleView(titleView)
    addSubviews(
      scrollView.addSubviews(
        imageView,
        descriptionLabel,
        datePicker
      ),
      saveButton
    )
  }
  
  // MARK: - Actions
  
  @IBAction private func datePickerValueChanged(_ sender: UIDatePicker) {
    dateChangedHandler(sender.date)
  }
  
  func allowSave(_ allow: Bool) {
    saveButton.isEnabled = allow
  }
  
  func allowEdit(_ allow: Bool) {
    datePicker.isHidden = !allow
    datePickerH.constant = allow ? 160 : 0
  }
  
  func showSuccess() {
    descriptionLabel.text = Text.success
  }
  
  // MARK: - Layout
  
  private lazy var datePickerH = datePicker.heightAnchor.constraint(equalToConstant: 160)
  
    private func setupLayout() {
        scrollView.activateConstraints {
            [$0.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
             $0.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
             $0.leadingAnchor.constraint(equalTo: leadingAnchor),
             $0.trailingAnchor.constraint(equalTo: trailingAnchor)]
        }
        imageView.activateConstraints {
            [$0.heightAnchor.constraint(equalToConstant: 80),
            $0.widthAnchor.constraint(equalToConstant: 80),
            $0.centerXAnchor.constraint(equalTo: centerXAnchor),
            $0.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30)]
        }
        descriptionLabel.activateConstraints {
            [$0.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            $0.widthAnchor.constraint(equalTo: widthAnchor, constant: -34),
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)]
        }
        datePicker.activateConstraints {
            [datePickerH,
            $0.widthAnchor.constraint(equalTo: widthAnchor, constant: -40),
            $0.centerXAnchor.constraint(equalTo: centerXAnchor),
            $0.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            $0.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)]
        }
        saveButton.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            $0.heightAnchor.constraint(equalToConstant: 44),
            $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)]
        }
  }
}
