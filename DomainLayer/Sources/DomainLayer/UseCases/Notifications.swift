//
//  File.swift
//  
//
//  Created by Артем Чжен on 25/06/23.
//

import Foundation
import UserNotifications

public protocol HasNotifications {
    var notifications: Notifications { get }
}

public protocol Notifications: AnyObject {
    var didBotifications: Bool { get set }
    func scheduleNotifications(inseconds seconds: TimeInterval, completion: (Bool) ->())
    
}

class NotifacationsImpl: Notifications {
    var didBotifications: Bool = true
    var getSchedule: GetSchedule
    
    init(getSchedule: GetSchedule) {
        self.getSchedule = getSchedule
    }
    
    func scheduleNotifications(inseconds seconds: TimeInterval, completion: (Bool) -> ()) {
        let date = Date(timeIntervalSinceNow: seconds)
        guard let timeToSleep = getSchedule.today()?.toBed else { return }
        
        let calendar = Calendar.current
        let currentTime = calendar.component(.minute, from: Date())
        let sleepTime = calendar.component(.minute, from: timeToSleep)
        print("111111111111")
        
        if didBotifications {
            return
        }
        
        if currentTime >= sleepTime {
            print("222222222222")
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = TextNotify.textTitleNotify.randomElement() ?? "The textBodyNotify is empty"
            notificationContent.body = TextNotify.textBodyNotify.randomElement() ?? "The textTitleNotify is empty"
            notificationContent.sound = .default
            
            let components = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "111", content: notificationContent, trigger: trigger)
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request, withCompletionHandler: nil)
            didBotifications = false
        }
    }
}

struct TextNotify {
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

