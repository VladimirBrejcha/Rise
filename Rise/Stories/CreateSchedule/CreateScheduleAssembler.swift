//
//  CreateScheduleAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class CreateScheduleAssembler {
    func assemble(onCreate: @escaping () -> Void) -> CreateScheduleViewController {
        let controller = Storyboard.createSchedule.instantiateViewController(of: CreateScheduleViewController.self)
        controller.createSchedule = DomainLayer.createSchedule
        controller.saveSchedule = DomainLayer.saveSchedule
        controller.onCreate = onCreate
        controller.stories = [
            .welcomeCreateSchedule,
            .sleepDurationCreateSchedule(
                sleepDurationOutput: { [weak controller] value in
                    controller?.sleepDurationValueChanged(value)
                },
                currentSleepDuration: { [weak controller] in
                    controller?.chosenSleepDuration
                }
            ),
            .wakeUpTimeCreateSchedule(
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
            .intensityCreateSchedule(
                scheduleIntensityOutput: { [weak controller] value in
                    controller?.intensityValueChanged(value)
                },
                currentIntensity: { [weak controller] in
                    controller?.chosenIntensity
                }
            ),
            .wentSleepCreateSchedule(
                wentSleepOutput: { [weak controller] value in
                    controller?.lastTimeWentSleepValueChanged(value)
                },
                currentWentSleepTime: { [weak controller] in
                    controller?.chosenLastTimeWentSleep
                }
            ),
            .scheduleCreatedCreateSchedule
        ]
        return controller
    }
}
