//
//  SelectAlarmMelodyViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 24/8/23.
//  Copyright © 2023 VladimirBrejcha. All rights reserved.
//

import UIKit.UIViewController
import Core
import DomainLayer

final class SelectAlarmMelodyViewController: UIViewController, ViewController {

    enum OutCommand {
        case save, close
    }
    private let out: Out

    typealias View = SelectAlarmMelodyView
    typealias Deps = HasSelectAlarmMelody & HasPlayMelodyPreview
    private let deps: Deps
    private let playMelodyPreview: PlayMelodyPreview

    // MARK: - LifeCycle

    init(deps: Deps, out: @escaping Out) {
        self.deps = deps
        self.playMelodyPreview = deps.playMelodyPreview
        self.out = out
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        self.view = SelectAlarmMelodyView(
            items: deps.selectAlarmMelody.melodies.map(\.localizedName),
            selectedItem: deps.selectAlarmMelody.selectedMelody.localizedName,
            itemSelected: { [weak self] title in
                guard let self else { return }
                self.rootView.selectedItem = title
                if let melody = self.melody(from: title) {
                    self.playMelodyPreview.play(melody: melody)
                } else {
                    log(.error, "melody \(self.rootView.selectedItem) not found")
                }

            },
            saveHandler: { [weak self] in
                guard let self else { return }
                if let melody = self.melody(from: self.rootView.selectedItem) {
                    self.deps.selectAlarmMelody(melody)
                } else {
                    log(.error, "melody \(self.rootView.selectedItem) not found")
                }
                self.playMelodyPreview.stop()
                self.out(.save)
            },
            closeHandler: { [weak self] in
                self?.playMelodyPreview.stop()
                self?.out(.close)
            }
        )
    }

    private func melody(from rawValue: String) -> Melody? {
        deps.selectAlarmMelody.melodies
            .first(where: { $0.localizedName == rawValue })
    }
}
