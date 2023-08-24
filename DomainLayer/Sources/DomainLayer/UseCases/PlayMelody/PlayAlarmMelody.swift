import AVFoundation
import Core
import DataLayer

final class PlayAlarmMelody: PlayMelody {

    private var alarmPlayer: AVPlayer?
    private let audioSession = AVAudioSession.sharedInstance()
    private var timeObserver: Any?

    private let selectAlarmMelody: SelectAlarmMelody

    private(set) var isActive: Bool = false

    init(selectAlarmMelody: SelectAlarmMelody) {
        self.selectAlarmMelody = selectAlarmMelody
    }

    deinit {
        stop()
    }

    // MARK: - Public methods

    public func play()  {
        guard isActive == false else { return }
        let melody = selectAlarmMelody.selectedMelody
        if let url = melody.path {
            alarmPlayer = AVPlayer(url: url)
        }
        guard let alarmPlayer else { return }
        isActive = true
        do {
            try audioSession.setCategory(.playback,
                                         mode: .default,
                                         options: [.allowAirPlay,
                                                   .mixWithOthers])
            try audioSession.setActive(true)
        } catch (let error) {
            log(.error, "Audio session error activation: \(error.localizedDescription)")
        }
        increaseVolume()
        loopAudio()
        alarmPlayer.play()
    }

    public func stop() {
        guard let alarmPlayer, isActive else { return }
        isActive = false
        alarmPlayer.pause()
        do {
            try audioSession.setActive(false)
        } catch (let error) {
            log(.error, "Audio session error deactivation: \(error.localizedDescription)")
        }
        if let timeObserver {
            alarmPlayer.removeTimeObserver(timeObserver)
        }
    }

    // MARK: - Private methods

    private func increaseVolume() {
        guard let alarmPlayer else { return }
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
        guard let alarmPlayer else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alarmPlayer.seek(to: .zero)
            alarmPlayer.play()
        }
    }
}
