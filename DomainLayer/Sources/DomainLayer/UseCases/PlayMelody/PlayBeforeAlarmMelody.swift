import AVFoundation
import Core

public protocol HasPlayBeforeAlarmMelody {
    var playBeforeAlarmMelody: PlayMelody { get }
}

final class PlayBeforeAlarmMelody: PlayMelody {

    private var player: AVPlayer?
    private let audioSession = AVAudioSession.sharedInstance()
    private var timeObserver: Any?

    private(set) var isActive: Bool = false

    init() {
        if let url = Melody.rainAndBirds.path {
            self.player = AVPlayer(url: url)
        }
    }

    deinit {
        stop()
    }

    // MARK: - Public methods

    public func play()  {
        guard let player, isActive == false else { return }
        isActive = true
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
        guard let player, isActive else { return }
        isActive = false
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
        guard let player else { return }
        player.volume = 0.1
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 5,
                                preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
            queue: DispatchQueue.main
        ) { _ in
            guard player.volume < 0.75 else { return }
            player.volume += 0.0125
        }
    }
}
