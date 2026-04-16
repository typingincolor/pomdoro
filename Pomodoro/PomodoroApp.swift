import SwiftUI

@main
struct PomodoroApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var manager: PomodoroManager
    @State private var settings: AppSettingsStore

    init() {
        let settingsStore = AppSettingsStore()
        let soundManager = SoundManager()
        let notificationManager = NotificationManager()
        let manager = PomodoroManager(
            timeProvider: SystemTimeProvider(),
            soundPlayer: soundManager,
            notificationSender: notificationManager,
            settings: settingsStore
        )
        self._manager = State(initialValue: manager)
        self._settings = State(initialValue: settingsStore)

        manager.timer1.setTime(
            minutes: settingsStore.defaultT1Minutes,
            seconds: settingsStore.defaultT1Seconds
        )
        manager.timer2.setTime(
            minutes: settingsStore.defaultT2Minutes,
            seconds: settingsStore.defaultT2Seconds
        )
    }

    var body: some Scene {
        WindowGroup("Pomodoro") {
            MainTimerView(
                settings: settings,
                scale: settings.windowSize.scaleFactor,
                onOpenSettings: { appDelegate.openSettings(settings: settings) }
            )
            .environment(manager)
            .frame(width: settings.windowSize.width)
            .fixedSize(horizontal: true, vertical: true)
        }
        .windowResizability(.contentSize)
    }
}
