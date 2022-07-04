//  
//  AdjustScheduleView.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AdjustScheduleView: UIView {
  
  private let closeHandler: () -> Void
  private let saveHandler: () -> Void
  private let dateChangedHandler: (Date) -> Void
  private let descriptionText: String
  
  // MARK: - Subviews
  
  private lazy var titleView: UIView = View.Title.make(
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
    scrollView.activateConstraints(
      scrollView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
      scrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
    )
    imageView.activateConstraints(
      imageView.heightAnchor.constraint(equalToConstant: 80),
      imageView.widthAnchor.constraint(equalToConstant: 80),
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30)
    )
    descriptionLabel.activateConstraints(
      descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
      descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -34),
      descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
    )
    datePicker.activateConstraints(
      datePickerH,
      datePicker.widthAnchor.constraint(equalTo: widthAnchor, constant: -40),
      datePicker.centerXAnchor.constraint(equalTo: centerXAnchor),
      datePicker.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
      datePicker.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
    )
    saveButton.activateConstraints(
      saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
      saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
      saveButton.heightAnchor.constraint(equalToConstant: 44),
      saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
    )
  }
}
