//
//  PlayAlarmMelody.swift
//  Rise
//
//  Created by VPDev on 05.07.2023.
//  Copyright © 2023 VladimirBrejcha. All rights reserved.
//

import AVFoundation

public protocol HasPlayAlarmMelody {
    var playAlarmMelody: PlayAlarmMelody { get }
}
public protocol PlayAlarmMelody {
    func play()
    func stop()
}
final class PlayAlarmMelodyImpl: PlayAlarmMelody {
    
    private var alarmPlayer: AVPlayer?
    
    let audioSession = AVAudioSession.sharedInstance()
    private var timeObserver: Any?
    
    init(melody: AlarmMelody = .defaultMelody) {
        if let url = melody.path {
            self.alarmPlayer = AVPlayer(url: url)
        }
    }

    // MARK: - Public methods

    public func play()  {
        guard let alarmPlayer = alarmPlayer else { return }
        smoothSound()
        seekAfterPlayinEnd()
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

   public func stop() {
       guard let alarmPlayer = alarmPlayer else { return }
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
        guard let alarmPlayer = alarmPlayer else { return }
        alarmPlayer.volume = 0.0
        timeObserver = alarmPlayer.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.25,
                                preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
            queue: DispatchQueue.main) { _ in
                guard alarmPlayer.volume < 1 else {
                    alarmPlayer.removeTimeObserver(self.timeObserver as Any)
                    return }
                alarmPlayer.volume += 0.025
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
        guard let alarmPlayer = alarmPlayer else { return }
        alarmPlayer.seek(to: .zero)
        alarmPlayer.play()
    }
    
}

