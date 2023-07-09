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
        seekAfterPlayinEnd()
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
        guard alarmPlayer.volume < 1 else { return }
        alarmPlayer.removeTimeObserver(timeObserver as Any)
    }

    // MARK: - Private methods

    private func smoothSound() {
        alarmPlayer.volume = 0.0
        timeObserver = alarmPlayer.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.25,
                                preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
            queue: DispatchQueue.main) { _ in
                guard self.alarmPlayer.volume < 1 else {
                    self.alarmPlayer.removeTimeObserver(self.timeObserver as Any)
                    return }
                print(self.alarmPlayer.volume)
                self.alarmPlayer.volume += 0.025
            }
    }

    // MARK: - NotificationCenter

    private func seekAfterPlayinEnd() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(actionAfterStopAudio),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }

    @objc private func actionAfterStopAudio() {
        alarmPlayer.seek(to: .zero)
        alarmPlayer.play()
    }
    
}

