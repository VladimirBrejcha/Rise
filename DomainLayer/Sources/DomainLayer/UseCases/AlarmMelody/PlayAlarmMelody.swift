//
//  PlayAlarmMelody.swift
//  Rise
//
//  Created by VPDev on 05.07.2023.
//  Copyright © 2023 VladimirBrejcha. All rights reserved.
//

import AVFoundation
import Core

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
        do {
            try audioSession.setCategory(.playback,
                                         mode: .default,
                                         options: [.allowAirPlay,
                                                   .mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            log(.error, "Audio session error active")
        }
        increaseVolume()
        loopAudio()
        alarmPlayer.play()
    }
    
    public func stop() {
        guard let alarmPlayer = alarmPlayer else { return }
        alarmPlayer.pause()
        do {
            try audioSession.setActive(false)
        } catch {
            log(.error, "Audio session error stop")
        }
        guard alarmPlayer.volume < 1 else { return }
        alarmPlayer.removeTimeObserver(timeObserver as Any)
    }
    
    // MARK: - Private methods
    
    private func increaseVolume() {
        guard let alarmPlayer = alarmPlayer else { return }
        alarmPlayer.volume = 0.0
        timeObserver = alarmPlayer.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5,
                                preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
            queue: DispatchQueue.main) { _ in
                guard alarmPlayer.volume < 1 else { return }
                alarmPlayer.volume += 0.0125
            }
    }
    
    // MARK: - NotificationCenter
    
    private func loopAudio() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(actionAfterStopAudio),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    @objc private func actionAfterStopAudio() {
        guard let alarmPlayer = alarmPlayer else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alarmPlayer.seek(to: .zero)
            alarmPlayer.play()
        }
    }
    
}

