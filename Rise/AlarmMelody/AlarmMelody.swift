//
//  AlarmMelody.swift
//  Rise
//
//  Created by VPDev on 05.07.2023.
//  Copyright © 2023 VladimirBrejcha. All rights reserved.
//

import AVFoundation

final class AlarmMelody {
    
    private let alarmPlayer: AVPlayer
    
    let audioSession = AVAudioSession.sharedInstance()
    private var timeObserver: Any?
    
    init?(melody: Melody = .defaultMelody) {
        guard let url = melody.path else { return nil }
        self.alarmPlayer = AVPlayer(url: url)
        smoothSound()
        
    }

    // MARK: - Public methods

    func alarmPlay()  {
        alarmPlayer.play()
        do {
            try audioSession.setCategory(.playback,
                                         mode: .moviePlayback,
                                         options: [.allowAirPlay,
                                                   .mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Audio session error active")
        }
        
    }

    func alarmPause() {
        alarmPlayer.pause()
        do {
            try audioSession.setActive(false)
        } catch {
            print("Audio session error pause")
        }
        alarmPlayer.removeTimeObserver(timeObserver as Any)
    }

    // MARK: - Private methods

    private func smoothSound() {
        alarmPlayer.volume = 0.0
       timeObserver = alarmPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 2, preferredTimescale: 1000),
                                            queue: DispatchQueue.main) { _ in
            guard self.alarmPlayer.volume < 1 else { return }
                self.alarmPlayer.volume += 0.1
        }
    }

    
}

