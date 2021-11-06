//
//  DomainLayer.swift
//  Rise
//
//  Created by Vladimir Korolev on 02.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

enum DomainLayer {
    static var getSunTime: GetSunTime {
        GetSunTimeUseCase(DataLayer.locationRepository, DataLayer.sunTimeRepository)
    }
    static var setOnboardingCompleted: SetOnboardingCompleted {
        SetOnboardingCompletedUseCase(DataLayer.userData)
    }
    static var getAppVersion: GetAppVersion {
        GetAppVersionUseCase()
    }
    static var prepareMail: PrepareMail {
        PrepareMailUseCase()
    }

    // MARK: - Schedule

    static var createSchedule: CreateSchedule {
        CreateScheduleImpl()
    }
    static var updateSchedule: UpdateSchedule {
        UpdateScheduleImpl(DomainLayer.createSchedule, DataLayer.scheduleRepository)
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
