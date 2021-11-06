//
//  DomainLayer.swift
//  Rise
//
//  Created by Vladimir Korolev on 02.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

enum DomainLayer {
    static var getPlan: GetPlan {
        GetPlanUseCase(DataLayer.defaultRisePlanRepository)
    }
    static var updatePlan: UpdatePlan {
        UpdatePlanUseCase(DataLayer.defaultRisePlanRepository)
    }
    static var deletePlan: DeletePlan {
        DeletePlanUseCase(DataLayer.defaultRisePlanRepository)
    }
    static var observePlan: ObservePlan {
        ObservePlanUseCase(DataLayer.defaultRisePlanRepository)
    }
    static var getSunTime: GetSunTime {
        GetSunTimeUseCase(DataLayer.locationRepository, DataLayer.sunTimeRepository)
    }
    static var getDailyTime: GetDailyTime {
        GetDailyTimeUseCase()
    }
    static var pausePlan: PausePlan {
        PausePlanUseCase(DataLayer.defaultRisePlanRepository)
    }
    static var confirmPlan: ConfirmPlan {
        ConfirmPlanUseCase(DataLayer.defaultRisePlanRepository)
    }
    static var reshedulePlan: ReshedulePlan {
        ReshedulePlanUseCase(DataLayer.defaultRisePlanRepository)
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
    static var createSchedule: CreateSchedule {
        CreateScheduleImpl()
    }
    static var createNextSchedule: CreateNextSchedule {
        CreateNextScheduleImpl()
    }
    static var saveSchedule: SaveSchedule {
        SaveScheduleImpl(DataLayer.scheduleRepository)
    }
    static var getSchedule: GetSchedule {
        GetScheduleImpl(DataLayer.scheduleRepository, DomainLayer.createNextSchedule)
    }
}
