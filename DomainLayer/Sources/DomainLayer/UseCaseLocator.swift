import DataLayer
import Core

public final class UseCaseLocator: UseCases {

    private let scheduleRepository: ScheduleRepository
    private let sunTimeRepository: SunTimeRepository
    private let locationRepository: LocationRepository
    private let userData: UserData
    private let notificationManager: NotificationManager

    public init(
        scheduleRepository: ScheduleRepository,
        sunTimeRepository: SunTimeRepository,
        locationRepository: LocationRepository,
        userData: UserData,
        notificationManager: NotificationManager
    ) {
        self.scheduleRepository = scheduleRepository
        self.sunTimeRepository = sunTimeRepository
        self.locationRepository = locationRepository
        self.userData = userData
        self.notificationManager = notificationManager
    }

    public var createSchedule: CreateSchedule {
        CreateScheduleImpl()
    }

    public var updateSchedule: UpdateSchedule {
        UpdateScheduleImpl(createSchedule, scheduleRepository)
    }

    public var deleteSchedule: DeleteSchedule {
        DeleteScheduleImpl(scheduleRepository, userData)
    }

    public lazy var getSunTime: GetSunTime = GetSunTimeImpl(
        locationRepository, sunTimeRepository
    )

    public var refreshSunTime: RefreshSunTime {
        RefreshSunTimeImpl(locationRepository, sunTimeRepository)
    }

    public var manageOnboardingCompleted: ManageOnboardingCompleted {
        ManageOnboardingCompletedImpl(userData)
    }
    
    public lazy
    var adjustSchedule: AdjustSchedule = AdjustScheduleImpl(
        scheduleRepository, userData
    )

    public var getSchedule: GetSchedule {
        GetScheduleImpl(scheduleRepository, createNextSchedule)
    }

    public var pauseSchedule: PauseSchedule {
        PauseScheduleImpl(userData)
    }

    public var manageActiveSleep: ManageActiveSleep {
        ManageActiveSleepImpl(userData, notificationManager)
    }

    public var suggestKeepAppOpened: SuggestKeepAppOpened {
        SuggestKeepAppOpenedImpl(userData)
    }

    public var preferredWakeUpTime: PreferredWakeUpTime {
        PreferredWakeUpTimeImpl(userData)
    }

    public var preventAppSleep: PreventAppSleep {
        PreventAppSleepImpl()
    }

    public var changeScreenBrightness: ChangeScreenBrightness {
        ChangeScreenBrightnessImpl()
    }

    public var prepareMail: PrepareMail {
        PrepareMailImpl()
    }

    public var getAppVersion: GetAppVersion {
        GetAppVersionImpl()
    }

    public var createNextSchedule: CreateNextSchedule {
        CreateNextScheduleImpl(userData)
    }

    public var saveSchedule: SaveSchedule {
        SaveScheduleImpl(scheduleRepository)
    }

    public lazy var notifyToSleep: NotifyToSleep = NotifyToSleepImpl(getSchedule: getSchedule, manageActiveSleep: manageActiveSleep, userData: userData)

    public lazy var scheduleSleepNotifications: ScheduleSleepNotifications = ScheduleSleepNotificationsImpl(
        getSchedule: getSchedule,
        scheduleRepository: scheduleRepository,
        notificationManager: notificationManager
    )

    public var playAlarmMelody: PlayAlarmMelody {
        PlayAlarmMelodyImpl()
    }

    public lazy var requestNotificationPermissions: RequestNotificationPermissions =
    RequestNotificationPermissionsImpl(
        notificationManager: notificationManager,
        userData: userData
    )
}
