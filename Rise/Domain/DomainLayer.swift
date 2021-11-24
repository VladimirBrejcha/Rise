//
//  DomainLayer.swift
//  Rise
//
//  Created by Vladimir Korolev on 02.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

enum DomainLayer {

    static var setOnboardingCompleted: SetOnboardingCompleted {
        SetOnboardingCompletedUseCase(DataLayer.userData)
    }
    static var getAppVersion: GetAppVersion {
        GetAppVersionUseCase()
    }
    static var prepareMail: PrepareMail {
        PrepareMailUseCase()
    }
    static var preferredWakeUpTime: PreferredWakeUpTime {
        PreferredWakeUpTimeImpl(DataLayer.userData)
    }
    static var suggestKeepAppUpened: SuggestKeepAppOpened {
        SuggestKeepAppOpenedImpl(DataLayer.userData)
    }
    static var preventAppSleep: PreventAppSleep {
        PreventAppSleepImpl()
    }
    static var changeScreenBrightness: ChangeScreenBrightness {
        ChangeScreenBrightnessImpl()
    }

    // MARK: - SunTime

    static var getSunTime: GetSunTime {
        GetSunTimeImpl(DataLayer.locationRepository, DataLayer.sunTimeRepository)
    }
    static var refreshSunTime: RefreshSunTime {
        RefreshSunTimeImpl(DataLayer.locationRepository, DataLayer.sunTimeRepository)
    }

    // MARK: - Schedule

    static var createSchedule: CreateSchedule {
        CreateScheduleImpl()
    }
    static var updateSchedule: UpdateSchedule {
        UpdateScheduleImpl(DomainLayer.createSchedule, DataLayer.scheduleRepository)
    }
    static var adjustSchedule: AdjustSchedule {
        AdjustScheduleImpl(DataLayer.scheduleRepository, DataLayer.userData)
    }
    static var createNextSchedule: CreateNextSchedule {
        CreateNextScheduleImpl(DataLayer.userData)
    }
    static var saveSchedule: SaveSchedule {
        SaveScheduleImpl(DataLayer.scheduleRepository)
    }
    static var getSchedule: GetSchedule {
        GetScheduleImpl(DataLayer.scheduleRepository, DomainLayer.createNextSchedule)
    }
    static var pauseSchedule: PauseSchedule {
        PauseScheduleImpl(DataLayer.userData)
    }
    static var deleteSchedule: DeleteSchedule {
        DeleteScheduleImpl(DataLayer.scheduleRepository, DataLayer.userData)
    }
}
