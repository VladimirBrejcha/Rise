//
//  CreateScheduleAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import DomainLayer

final class CreateScheduleAssembler {
  func assemble(deps: HasCreateScheduleUseCase & HasSaveSchedule) -> CreateScheduleViewController {
    let controller = Storyboard.createSchedule.instantiateViewController(
      of: CreateScheduleViewController.self
    )
    controller.createSchedule = deps.createSchedule
    controller.saveSchedule = deps.saveSchedule
    controller.stages = [
      .welcome,
      .sleepDuration(
        sleepDurationOutput: { [weak controller] value in
          controller?.sleepDurationValueChanged(value)
        },
        currentSleepDuration: { [weak controller] in
          controller?.chosenSleepDuration
        }
      ),
      .wakeUpTime(
        toBedTimeOutput: { [weak controller] value in
          controller?.toBedTimeValueChanged(value)
        },
        wakeUpTimeOutput: { [weak controller] value in
          controller?.wakeUpTimeValueChanged(value)
        },
        currentSleepDuration: { [weak controller] in
          controller?.chosenSleepDuration
        },
        currentWakeUpTime: { [weak controller] in
          controller?.chosenWakeUpTime
        }
      ),
      .intensity(
        scheduleIntensityOutput: { [weak controller] value in
          controller?.intensityValueChanged(value)
        },
        currentIntensity: { [weak controller] in
          controller?.chosenIntensity
        }
      ),
      .wentSleep(
        wentSleepOutput: { [weak controller] value in
          controller?.lastTimeWentSleepValueChanged(value)
        },
        currentWentSleepTime: { [weak controller] in
          controller?.chosenLastTimeWentSleep
        }
      ),
      .scheduleCreated
    ]
    return controller
  }
}
