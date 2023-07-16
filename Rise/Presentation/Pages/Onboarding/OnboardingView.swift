//
//  OnboardingView.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension Onboarding {

  final class View: UIView, UIScrollViewDelegate {

    private var content: [ContentView.Model] = []
    private var completedHandler: (() -> Void)?
    private var currentPageIndex: Int = 0
    private var offset: CGFloat = 0.0
    private var buttonTitle: String = ""
    private var finalButtonTitle: String = ""

    // MARK: - Subviews

    private lazy var button: Button = {
      let button = Button()
      button.onTouchUp = { [weak self] in
        guard let self = self else { return }
        if self.currentPageIndex < self.content.count - 1 {
          self.currentPageIndex += 1
          self.pageControl.currentPage = self.currentPageIndex
          self.scrollToCurrentPage()
          self.updateButtonTitle()
        } else {
          self.completedHandler?()
        }
      }
      return button
    }()

    private lazy var scrollView: UIScrollView = {
      let view = UIScrollView()
      view.isPagingEnabled = true
      view.showsHorizontalScrollIndicator = false
      view.delegate = self
      return view
    }()

    private lazy var pagesContainerView: UIStackView = {
      let stack = UIStackView()
      stack.axis = .horizontal
      stack.clipsToBounds = false
      return stack
    }()

    private lazy var pageControl: UIPageControl = {
      let pageControl = UIPageControl()
      pageControl.isUserInteractionEnabled = false
      return pageControl
    }()

    // MARK: - LifeCycle

    convenience init(
      content: [ContentView.Model],
      buttonTitle: String,
      finalButtonTitle: String,
      completedHandler: @escaping () -> Void
    ) {
      self.init(frame: .zero)
      self.content = content
      self.buttonTitle = buttonTitle
      self.finalButtonTitle = finalButtonTitle
      self.completedHandler = completedHandler
      setup()
    }

    private func setup() {
      setupViews()
      setupLayout()
    }

    private func setupViews() {
      addBackgroundView(.rich)
      addSubviews(
        scrollView.addSubviews(
          pagesContainerView
        ),
        pageControl,
        button
      )
      content.forEach { model in
        pagesContainerView.addArrangedSubview(ContentView(model: model))
      }
      pageControl.numberOfPages = content.count
      pageControl.currentPage = currentPageIndex
      button.setTitle(buttonTitle, for: .normal)
    }

    private func updateButtonTitle() {
      if currentPageIndex < content.count - 1 {
        button.setTitle(self.buttonTitle, for: .normal)
      } else {
        button.setTitle(self.finalButtonTitle, for: .normal)
      }
    }

    // MARK: - Layout

    private func setupLayout() {
      button.activateConstraints(
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44),
        button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24),
        button.heightAnchor.constraint(equalToConstant: 44)
      )
      scrollView.activateConstraints(
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
        scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
      )
      pagesContainerView.activateConstraints(
        pagesContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        pagesContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        pagesContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        pagesContainerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
      )
      pagesContainerView.arrangedSubviews.forEach { view in
        view.activateConstraints(
          view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        )
      }
      pageControl.activateConstraints(
        pageControl.centerXAnchor.constraint(equalTo: button.centerXAnchor),
        pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16)
      )
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      offset = scrollView.contentOffset.x / scrollView.bounds.width
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      if !decelerate {
        pageChanged()
      }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
      pageChanged()
    }

    private func pageChanged() {
      let oldPageIndex = currentPageIndex
      currentPageIndex = Int(round(offset))
      if oldPageIndex == currentPageIndex { return }
      pageControl.currentPage = currentPageIndex
      updateButtonTitle()
        (pagesContainerView.arrangedSubviews[oldPageIndex] as! ContentView).animate(false, animation: .identity)
        (pagesContainerView.arrangedSubviews[currentPageIndex] as! ContentView).animate(true, animation: transforms[currentPageIndex])
    }

      func pageChanged1() {
          (pagesContainerView.arrangedSubviews[currentPageIndex] as! ContentView).animate(true, animation: transforms[currentPageIndex])
      }

      var transforms: [CGAffineTransform] =
      [
        .init(rotationAngle: (.pi / 4)),
        .init(translationX: 0, y: 12),
        .init(scaleX: 1.15, y: 1.15),
        .init(translationX: 0, y: 12),
        .init(translationX: 0, y: 12),
      ]

    private func scrollToCurrentPage() {
      scrollView.setContentOffset(
        .init(x: CGFloat(currentPageIndex) * scrollView.bounds.width, y: 0),
        animated: true
      )
    }
  }
}
