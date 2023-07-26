import Foundation
import UserNotifications
import UIKit
import Core
import Combine
import DataLayer

public protocol HasNotification {
    var notification: ScheduleNotificationDelegate { get }
}

public protocol ScheduleNotificationDelegate: AnyObject {
    func callAsFunction()
}

class NotificationImpl: NSObject, ScheduleNotificationDelegate, UNUserNotificationCenterDelegate {
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
    
    func generateSleepNotification(for date: Date) {
        let sleepComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let sleepTitle = NotificationText.textTitleNotify.randomElement() ?? "Dreamland's Champion"
        let sleepBody = NotificationText.textBodyNotify.randomElement() ?? "🌟 Time to catch some Zs, champ! Your bed is calling and dreams await. Charge up for tomorrow's adventures!”🛌💤"
        NotificationManager.createNotification(title: sleepTitle, body: sleepBody, components: sleepComponents, categoryIdentifier: "SleepCategory")
    }
    
    func generateWakeUpNotification(for date: Date) {
        let wakeUpComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let wakeUpTitle = NotificationText.textTitleWakeUp.randomElement() ?? "🌞 Rise and Shine: A New Day Beckons!"
        let wakeUpBody = NotificationText.textBodyWakeUp.randomElement() ?? "☀️ Good morning! It's a brand-new day filled with possibilities. Time to rise and shine, and make the most of it!"
        NotificationManager.createNotification(title: wakeUpTitle, body: wakeUpBody, components: wakeUpComponents)
    }
    
    func callAsFunction() {
        NotificationManager.cancelAllPendingRequests()
        
        guard let schedule = Optional(getSchedule.forNextDays(numberOfDays: 10, startToday: true)) else { return }
        for day in schedule {
            generateSleepNotification(for: day.toBed)
            generateWakeUpNotification(for: day.wakeUp)
        }
    }
}
    
    public struct NotificationText {
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
        
        static var textTitleWakeUp: [String] = ["🌞 Rise and Shine: A New Day Beckons!",
                                                "🔥 Embrace the Morning: Your Time to Thrive!",
                                                "🌄 Morning Glow: Ignite Your Potential!",
                                                "🌅 Seize the Day: Opportunities Await!",
                                                "🌤️ Good Morning, World Changer!",
                                                "🌞 Wake Up and Conquer: Your Day Awaits!",
                                                "🌤️ Greetings from the Sunrise: Let's Excel!",
                                                "🌞 Bright Beginnings: Your Journey Starts Now!",
                                                "🔆 Morning Magic: Your Adventure Begins!",
                                                "🌞 Unlock Your Potential: A New Day Dawns!"]
        
        static var textBodyWakeUp: [String] = ["☀️ Good morning! It's a brand-new day filled with possibilities. Time to rise and shine, and make the most of it!",
                                               "🐦 Wake up, sleepyhead! Today is your day to shine. Embrace the new day with open arms and a happy heart.",
                                               "😄 Hello, sunshine! It's time to wake up and fill your day with positive vibes. Let's do this!",
                                               "🌟 Hey there, early bird! It's time to get up and conquer your day. Let's start this journey together.",
                                               "🌈 Rise and shine! The world is waiting for your unique touch. Let's greet the day with a smile.",
                                               "🚀 Hey, did you know that the best way to predict your future is to create it? Let's start creating right now, wake up!",
                                               "✨ Good morning, star! The early hours have a magic that can transform your day. Time to wake up and catch the magic!",
                                               "🎯 Wakey, wakey! Success is calling and it wants to meet you early today. Let's step into a day of accomplishments.",
                                               "💪 Time to rise, you fantastic human! Let's kickstart the day with enthusiasm and a winning spirit.",
                                               "🏆 Morning, champ! It's time to leave the dreamland and step into your dreams. Get up and seize the day!"]
    }
