//
//  CreateScheduleAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class CreateScheduleAssembler {
    func assemble() -> CreateScheduleViewController {
        let controller = Storyboard.createSchedule.instantiateViewController(of: CreateScheduleViewController.self)
        controller.createSchedule = DomainLayer.createSchedule
        controller.saveSchedule = DomainLayer.saveSchedule
        controller.stories = [
            .welcomeCreateSchedule,
            .sleepDurationCreateSchedule(
                sleepDurationOutput: { [weak controller] value in
                    controller?.sleepDurationValueChanged(value)
                },
                presettedSleepDuration: controller.choosenSleepDuration
            ),
            .wakeUpTimeCreateSchedule(
                wakeUpTimeOutput: { [weak controller] value in
                    controller?.wakeUpTimeValueChanged(value)
                },
                presettedWakeUpTime: controller.choosenWakeUpTime
            ),
            .wentSleepCreateSchedule(
                wentSleepOutput: { [weak controller] value in
                    controller?.lastTimeWentSleepValueChanged(value)
                },
                presettedWentSleepTime: controller.choosenLastTimeWentSleep
            ),
            .scheduleCreatedCreateSchedule
        ]
        return controller
    }
}
