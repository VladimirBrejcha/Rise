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

  var setOnboardingCompleted: SetOnboardingCompleted {
    SetOnboardingCompletedUseCase(userData)
  }

  var adjustSchedule: AdjustSchedule {
    AdjustScheduleImpl(scheduleRepository, userData)
  }

  var getSchedule: GetSchedule {
    GetScheduleImpl(scheduleRepository, DomainLayer.createNextSchedule)
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
}
