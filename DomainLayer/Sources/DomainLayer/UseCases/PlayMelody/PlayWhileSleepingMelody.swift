import AVFoundation
import Core

final class PlayWhileSleepingMelody: PlayMelody {

    private var player: AVPlayer?
    private let audioSession = AVAudioSession.sharedInstance()
    private var timeObserver: Any?

    init(melody: Melody) {
        if let url = melody.path {
            self.player = AVPlayer(url: url)
        }
    }

    // MARK: - Public methods

    public func play()  {
        guard let player = player else { return }
        do {
            try audioSession.setCategory(.playback,
                                         mode: .default,
                                         options: [])
            try audioSession.setActive(true)
        } catch (let error) {
            log(.error, "Audio session error activation: \(error.localizedDescription)")
        }
        increaseVolume()
        player.play()
    }

    public func stop() {
        guard let player = player else { return }
        player.pause()
        do {
            try audioSession.setActive(false)
        } catch (let error) {
            log(.error, "Audio session error deactivation: \(error.localizedDescription)")
        }
        if let timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }

    // MARK: - Private methods

    private func increaseVolume() {
        guard let player = player else { return }
        player.volume = 0.0
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5,
                                preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
            queue: DispatchQueue.main
        ) { _ in
            guard player.volume < 1 else { return }
            player.volume += 0.0125
        }
    }
}
