import Foundation
import UserNotifications
import UIKit
import Core
import Combine
import DataLayer

public protocol HasNotification {
    var notification: RefreshScheduleNotifications { get }
}

public protocol RefreshScheduleNotifications: AnyObject {
    func callAsFunction()
}

class NotificationImpl: NSObject, RefreshScheduleNotifications, UNUserNotificationCenterDelegate {
    
    private let scheduleRepository: ScheduleRepository
    private var cancellable: AnyCancellable?
    
    var getSchedule: GetSchedule
    
    init(getSchedule: GetSchedule, scheduleRepository: ScheduleRepository) {
        self.getSchedule = getSchedule
        self.scheduleRepository = scheduleRepository
        
        super.init()
        self.cancellable = scheduleRepository.publisher().sink(receiveValue: { [weak self] _ in
            DispatchQueue.main.async {
                self?.callAsFunction()
            }
        })
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func callAsFunction() {
        NotificationManager.cancelAllPendingRequests()
        if let timeToSleepNextDays = Optional(getSchedule.forNextDays(numberOfDays: 10, startToday: true)) {
            for date in timeToSleepNextDays {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year,.month,.day, .hour, .minute, .second], from: date.toBed)
                let title = TextNotify.textTitleNotify.randomElement() ?? "Dreamland's Champion"
                let body = TextNotify.textBodyNotify.randomElement() ?? "🌟 Time to catch some Zs, champ! Your bed is calling and dreams await. Charge up for tomorrow's adventures!”🛌💤"
                
                NotificationManager.createNotification(title: title, body: body, components: components)
            }
        }
    }
}

public struct TextNotify {
    static var  textBodyNotify: [String] = ["🌟 “Time to catch some Zs, champ! Your bed is calling and dreams await. Charge up for tomorrow's adventures!” 🛌💤",
                                            "🌜 “The stars are out and the night is young. Head to bed and set sail to Dreamland. Tomorrow’s a fresh start!” 🚀",
                                            "🌙 You've given today your all, now it's time to embrace the night! Slip into your dreams and let your mind be free. Sweet dreams! 🍬",
                                            "⏰ Tick tock! It’s your sleep o’clock. Slide under those comfy sheets and let the Sandman whisk you away. Nighty night! 😴",
                                            "🍃 Nature’s lullaby is playing. Close your eyes and sync with the rhythm of the night. Let’s recharge together! 🌳",
                                            "✨ Tonight is the night to dream big! Hop into bed and let your imagination soar. See you in the morning, refreshed and ready! ☀️",
                                            "📚 Just like a book, each day has an end. Time to bookmark this day and get cozy. The next chapter awaits! 🛌",
                                            "💪 Your day was a workout for the mind. Now, let’s work on resting those muscles. Your bed is your gym tonight! 🌛",
                                            "🧘 Time for some night-time yoga – for the mind! Lie down, take deep breaths, and let your dreams stretch your imagination. Rest well! 🛌",
                                            "🏰 Your bed is your castle, and you’re royalty! Retreat into your cozy kingdom for a night of peace and dreams. Long live the king/queen! 👑"]
    
    static var textTitleNotify: [String] = ["Dreamland's Champion",
                                            "Starlit Voyage",
                                            "Embrace the Night",
                                            "Sleep O'Clock",
                                            "Nature's Lullaby",
                                            "Dream Big Tonight",
                                            "Bookmark the Day",
                                            "Bedroom Gym",
                                            "Dream Yoga",
                                            "Royal Slumber"]
}
