import AVFoundation
import Core

final class PlayAlarmMelody: PlayMelody {

    private var alarmPlayer: AVPlayer?
    private let audioSession = AVAudioSession.sharedInstance()
    private var timeObserver: Any?

    init(melody: Melody = .defaultMelody) {
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
        } catch (let error) {
            log(.error, "Audio session error activation: \(error.localizedDescription)")
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
        } catch (let error) {
            log(.error, "Audio session error deactivation: \(error.localizedDescription)")
        }
        if let timeObserver {
            alarmPlayer.removeTimeObserver(timeObserver)
        }
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
