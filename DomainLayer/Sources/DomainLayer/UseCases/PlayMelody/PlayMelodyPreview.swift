import AVFoundation
import Core

public protocol HasPlayMelodyPreview {
    var playMelodyPreview: PlayMelodyPreview { get }
}

public protocol PlayMelodyPreview {
    func play(melody: Melody)
    func stop()
}

final class PlayMelodyPreviewImpl: PlayMelodyPreview {

    private var player: AVPlayer?
    private let audioSession = AVAudioSession.sharedInstance()
    private var isActive: Bool = false

    deinit {
        stop()
    }

    // MARK: - Public methods

    public func play(melody: Melody)  {
        if isActive { stop() }
        if let url = melody.path {
            self.player = AVPlayer(url: url)
        }
        guard let player else { return }
        isActive = true
        do {
            try audioSession.setCategory(.playback,
                                         mode: .default,
                                         options: [])
            try audioSession.setActive(true)
        } catch (let error) {
            log(.error, "Audio session error activation: \(error.localizedDescription)")
        }
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
    }
}
