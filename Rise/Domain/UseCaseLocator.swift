//
//  UseCaseLocator.swift
//  Rise
//
//  Created by Vladimir Korolev on 14.05.2022.
//  Copyright © 2022 VladimirBrejcha. All rights reserved.
//

final class UseCaseLocator: UseCases {

  private let scheduleRepository: ScheduleRepository
  private let sunTimeRepository: SunTimeRepository
  private let locationRepository: LocationRepository
  private let userData: UserData

  init(scheduleRepository: ScheduleRepository,
       sunTimeRepository: SunTimeRepository,
       locationRepository: LocationRepository,
       userData: UserData
  ) {
    self.scheduleRepository = scheduleRepository
    self.sunTimeRepository = sunTimeRepository
    self.locationRepository = locationRepository
    self.userData = userData
  }

  var createSchedule: CreateSchedule {
    CreateScheduleImpl()
  }

  var updateSchedule: UpdateSchedule {
    UpdateScheduleImpl(createSchedule, scheduleRepository)
  }

  var deleteSchedule: DeleteSchedule {
    DeleteScheduleImpl(scheduleRepository, userData)
  }

  var getSunTime: GetSunTime {
    GetSunTimeImpl(locationRepository, sunTimeRepository)
  }

  var refreshSunTime: RefreshSunTime {
    RefreshSunTimeImpl(locationRepository, sunTimeRepository)
  }

  var manageOnboardingCompleted: ManageOnboardingCompleted {
    ManageOnboardingCompletedImpl(userData)
  }

  var adjustSchedule: AdjustSchedule {
    AdjustScheduleImpl(scheduleRepository, userData)
  }

  var getSchedule: GetSchedule {
    GetScheduleImpl(scheduleRepository, createNextSchedule)
  }

  var pauseSchedule: PauseSchedule {
    PauseScheduleImpl(userData)
  }

  var manageActiveSleep: ManageActiveSleep {
    ManageActiveSleepImpl(userData)
  }

  var suggestKeepAppOpened: SuggestKeepAppOpened {
    SuggestKeepAppOpenedImpl(userData)
  }

  var preferredWakeUpTime: PreferredWakeUpTime {
    PreferredWakeUpTimeImpl(userData)
  }

  var preventAppSleep: PreventAppSleep {
    PreventAppSleepImpl()
  }

  var changeScreenBrightness: ChangeScreenBrightness {
    ChangeScreenBrightnessImpl()
  }

  var prepareMail: PrepareMail {
    PrepareMailUseCase()
  }

  var getAppVersion: GetAppVersion {
    GetAppVersionUseCase()
  }

  var createNextSchedule: CreateNextSchedule {
    CreateNextScheduleImpl(userData)
  }

  var saveSchedule: SaveSchedule {
    SaveScheduleImpl(scheduleRepository)
  }
}
