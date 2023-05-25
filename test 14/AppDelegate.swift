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
		AppManager.setup(AppManager.Config(app: .test14,
										   displayName: "test 14",
										   appId: 123,
										   appToken: "salkjdlkasjdlkksjdas",
										   marketplaceId: 23,
										   dynamicURIPrefix: "https://smart.link"))
		return true
	}
}
