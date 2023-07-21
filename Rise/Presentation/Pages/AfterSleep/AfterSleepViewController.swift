//  
//  AfterSleepViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core
import DomainLayer

final class AfterSleepViewController: UIViewController, ViewController {

    enum OutCommand {
        case adjustSchedule(currentSchedule: Schedule, toBed: Date)
        case finish
    }

    typealias Deps = HasManageActiveSleep & HasGetSchedule & HasChangeScreenBrightness
    typealias View = AfterSleepView

    private let manageActiveSleep: ManageActiveSleep
    private let yesterdaySchedule: Schedule?
    private let changeScreenBrightness: ChangeScreenBrightness
    private let out: Out

    private let todaySchedule: Schedule?
    private let wentSleepTime: Date
    private let totalSleepTime: Int
    private let currentTime: Date = Date()

    // MARK: - LifeCycle

    init(deps: Deps, out: @escaping Out) {
        self.manageActiveSleep = deps.manageActiveSleep
        self.todaySchedule = deps.getSchedule.today()
        self.yesterdaySchedule = deps.getSchedule.yesterday()
        self.wentSleepTime = deps.manageActiveSleep.sleepStartedAt ?? Date()
        self.totalSleepTime = Int(currentTime.timeIntervalSince(wentSleepTime)) / 60
        self.out = out
        self.changeScreenBrightness = deps.changeScreenBrightness
        super.init(nibName: nil, bundle: nil)
        manageActiveSleep.endSleep()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = AfterSleepView(
            doneHandler: { [unowned self] in
                out(.finish)
            },
            adjustScheduleHandler: { [unowned self] in
                if let schedule = todaySchedule {
                    out(.adjustSchedule(currentSchedule: schedule, toBed: wentSleepTime))
                }
            },
            model: .init(
                image: Self.images.randomElement()!,
                title: Self.titles.randomElement()!,
                quote: Self.motivationalQuotes.randomElement()!,
                lines: makeDescriptionText(
                    wentSleepTime: wentSleepTime.HHmmString,
                    lateBy: {
                        guard let schedule = yesterdaySchedule else {
                            return nil
                        }
                        let minutes = minutes(
                            sinceScheduled: schedule,
                            wentSleepAt: wentSleepTime
                        )
                        return minutes > 0 ? minutes.HHmmString : nil
                    }(),
                    wokeUpTime: currentTime.HHmmString,
                    totalSleepTime: totalSleepTime > 0 ? totalSleepTime.HHmmString : nil
                )
            ),
            showAdjustSchedule: shouldAdjustSchedule(
                schedule: yesterdaySchedule,
                wentSleepTime: wentSleepTime
            )
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        changeScreenBrightness(to: .high)
        rootView.animate(true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        rootView.animate(false)
    }

    private static let motivationalQuotes = [
        "Sleep is the best meditation.\n- Dalai Lama",
        "Early to bed and early to rise makes a man healthy, wealthy, and wise.\n- Benjamin Franklin",
        "Sleep is that golden chain that ties health and our bodies together.\n- Thomas Dekker",
        "Your future depends on your dreams, so go to sleep.\n- Mesut Barazany",
        "Sleep is the golden key that opens the palace of eternity.\n- John Milton",
        "A well-spent day brings happy sleep.\n- Leonardo da Vinci",
        "Sleep is the ultimate act of self-care.\n- Unattributed",
        "Better to get up late and be wide awake than to get up early and be asleep all day.\n- Unattributed",
        "Sleep is the real beauty secret, but a good bed and pillow can help.\n- Unattributed",
        "Sleeping is a cure to forget about pain, problems, stress, and everything for a while.\n- Unattributed",
        "There is more refreshment and stimulation in a nap, even of the briefest, than in all the alcohol ever distilled.\n- Edward Lucas",
        "Even a soul submerged in sleep is hard at work and helps make something of the world.\n- Heraclitus",
        "A good laugh and a long sleep are the best cures in the doctor's book.\n- Irish Proverb",
        "Sleep is the best time to repair, but it's hard to get a good night's rest when we don't dial the inner chatter down.\n- Kris Carr",
        "Sleeping is no mean art: for its sake one must stay awake all day.\n- Friedrich Nietzsche",
        "There is no sunrise so beautiful that it is worth waking me up to see it.\n- Mindy Kaling",
        "The amount of sleep required by the average person is five minutes more.\n- Wilson Mizner",
        "True silence is the rest of the mind, and is to the spirit what sleep is to the body, nourishment and refreshment.\n- William Penn",
        "The nicest thing for me is sleep, then at least I can dream.\n- Marilyn Monroe",
        "When you lie down, you will not be afraid. Your sleep will be sweet.\n- Proverbs 3:24",
        "Think in the morning. Act in the noon. Eat in the evening. Sleep in the night.\n- William Blake",
        "No day is so bad it can't be fixed with a nap.\n- Carrie Snow",
        "Man is a genius when he is dreaming.\n- Akira Kurosawa",
        "To achieve the impossible dream, try going to sleep.\n- Joan Klempner",
        "Never waste any time you can spend sleeping.\n- Frank H. Knight",
        "Dreams are the playground of unicorns.\n- Unknown",
        "There are no rules for good sleep. There are only good beds.\n- Unknown",
        "Sweet dreams are made of peace and love.\n- Unknown",
        "Peace begins with a good eight hours of sleep.\n- Unknown",
        "Sleep is like a time machine to breakfast.\n- Unknown",
        "Sleep is the key of success.\n- Unknown",
        "There are some secrets that only sleep tells.\n- Unknown",
        "Wake up with determination, go to bed with satisfaction.\n- Unknown",
        "If you're having a hard day, just remember that at least you're not an insomniac vampire.\n- Unknown",
        "A well-spent day leads to happy sleep, so spend your days well.\n- Unknown",
        "If a nap is good, then a whole night's sleep must be better.\n- Unknown",
        "If you love your bed, it loves you back.\n- Unknown",
        "Rest your mind so you can hear the whispers of your heart.\n- Unknown",
        "May your pillows be soft, your blankets warm, and your mind at peace.\n- Unknown",
        "Let sleep be your medicine and your bed be your sanctuary.\n- Unknown",
        "Let go of today's troubles and embrace tomorrow's dreams.\n- Unknown",
        "Life is better in pajamas.\n- Unknown",
        "Sleeping is a gateway to a world where anything is possible.\n- Unknown",
        "Embrace your dreams, through the night. Tomorrow comes with a whole new light.\n- Unknown",
        "Sleep is the reset button of life. Press it regularly.\n- Unknown",
        "Each night, when I go to sleep, I die. And the next morning, when I wake up, I am reborn.\n- Mahatma Gandhi",
        "Let her sleep, for when she wakes, she will move mountains.\n- Napoleon Bonaparte",
        "Let him sleep, for when he wakes, he will move mountains.\n- Napoleon Bonaparte",
        "The moon looks upon many night flowers; the night flowers see but one moon.\n- Jean Ingelow",
        "The bed is a bundle of paradoxes: we go to it with reluctance, yet we quit it with regret.\n- Charles Caleb Colton",
        "In dreams, we enter a world that's entirely our own.\n- Albus Dumbledore",
        "Sleep is an investment in the energy you need to be effective tomorrow.\n- Tom Roth"
    ]

    private static let images: [UIImage] = [
        "bird.fill",
        "mountain.2.fill",
        "lizard.fill",
        "hare.fill",
        "carrot.fill",
        "ladybug.fill",
        "fish.fill",
        "trophy.fill",
        "cloud.fill",
        "flame.fill",
    ].compactMap(UIImage.init(systemName:))

    private static let titles: [String] = [
        "Good Morning!",
        "Rise and Shine!",
        "Good Day, Sunshine!",
        "Wakey Wakey!",
        "Hello, Early Bird!",
        "Ready to Conquer the Day?",
        "Up and At 'Em!",
        "Hello, Sunshine!",
        "Time to Sparkle and Shine!",
        "Welcome to a New Day!",
    ]

    private func makeDescriptionText(
        wentSleepTime: String,
        lateBy: String?,
        wokeUpTime: String,
        totalSleepTime: String?
    ) -> [(text: String, image: String)] {
        var lines: [(String, String)] = [("Went sleep at \(wentSleepTime)", "bed.double.fill")]
        if let lateBy = lateBy {
            lines.append(("This is \(lateBy) later than scheduled.", "clock.badge.xmark.fill"))
        }
        lines.append(("Woke up at \(wokeUpTime)", "mug.fill"))
        if let totalSleepTime = totalSleepTime {
            lines.append(("Time in bed: \(totalSleepTime)", "heart.fill"))
        }
        return lines
    }

    private func shouldAdjustSchedule(
        schedule: Schedule?,
        wentSleepTime: Date
    ) -> Bool {
        guard let schedule = schedule else {
            return false
        }
        return (-20...20)
            .contains(
                minutes(sinceScheduled: schedule, wentSleepAt: wentSleepTime)
            )
    }

    private func minutes(sinceScheduled: Schedule, wentSleepAt: Date) -> Int {
        calendar.dateComponents(
            [.minute],
            from: sinceScheduled.toBed.changeDayStoringTime(to: wentSleepAt),
            to: wentSleepAt
        ).minute ?? 0
    }
}
