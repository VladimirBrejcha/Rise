//
//  AudioPlayer.swift
//  Rise
//
//  Created by Владимир Королев on 11.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import AVFoundation

struct Sound: Equatable {
    let resource: String
    let fileExtension: String
}

final class AudioPlayer {
    private var player: AVAudioPlayer?
    
    func play(sound: Sound, loop: Bool = false) throws {
        guard let url = sound.url else { throw RiseError.cantBuildURL }
        
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        player?.numberOfLoops = loop ? Int.max : 0
        player?.play()
    }
    
    func stop() throws {
        try AVAudioSession.sharedInstance().setActive(false)
        player?.stop()
    }
}

fileprivate extension Sound {
    var url: URL? {
        Bundle.main.url(forResource: self.resource, withExtension: self.fileExtension)
    }
}
