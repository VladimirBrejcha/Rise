public protocol HasPlayAlarmMelody {
    var playAlarmMelody: PlayMelody { get }
}

public protocol HasPlayWhileSleepingMelody {
    var playWhileSleepingMelody: PlayMelody { get }
}

public protocol HasPlayBeforeAlarmMelody {
    var playBeforeAlarmMelody: PlayMelody { get }
}

public protocol PlayMelody {
    func play()
    func stop()
    var isActive: Bool { get }
}
