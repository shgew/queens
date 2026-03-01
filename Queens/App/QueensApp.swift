import SwiftUI

@main
struct QueensApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

	var body: some Scene {
		WindowGroup {
			GameView()
		}
	}
}
