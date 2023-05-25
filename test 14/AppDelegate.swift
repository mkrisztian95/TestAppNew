//
//  AppDelegate.swift
//  serveture
//
//  Created by Daniel Tartaglia on 7/13/15.
//  Copyright © 2015 Haneke Design. All rights reserved.
//

import UIKit
import ServetureFramework
import PluggableAppDelegate

@UIApplicationMain
public final class AppDelegate: PluggableApplicationDelegate {

	private override init() {
		super.init()
		self.window = UIWindow(frame: UIScreen.main.bounds)
		ViewManager.shared.window = window
	}

	public override var services: [ApplicationService] {
		return [
			GeneralAppDelegate(),
			FirebaseApplicationService.shared,
			NotificationApplicationService.shared,
			LocationApplicationService.shared,
			RequestApplicationService.shared
		]
	}
}

public class GeneralAppDelegate: NSObject, ApplicationService {

	public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		AppManager.setup(AppManager.Config(app: .debbie,
										   displayName: "Template",
										   appId: 0,
										   appToken: "template",
										   marketplaceId: 145,
										   dynamicURIPrefix: "https://debbie.page.link"))
		return true
	}
}
