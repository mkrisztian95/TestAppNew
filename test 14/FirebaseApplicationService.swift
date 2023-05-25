//
//  FirebaseApplicationService.swift
//  WorkN
//
//  Created by Leandro Sousa on 13/11/20.
//  Copyright © 2020. WorkN. All rights reserved.
//

import UIKit
import Firebase
import ServetureFramework
import PluggableAppDelegate

public class FirebaseApplicationService: NSObject, ApplicationService {

	public static let shared = FirebaseApplicationService()

	private override init() {
		super.init()
	}

	public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()
		DataManager.instance.googleKey = FirebaseApp.app()?.options.apiKey

		handleDynamicLinkAtLaunch(application, launchOptions: launchOptions)
		NotificationCenter.default.addObserver(self, selector: #selector(logEvent), name: Notification.Name("logEvent"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(setUserProperty), name: Notification.Name("setUserProperty"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(reportError), name: Notification.Name("reportError"), object: nil)
		return true
	}

	public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
		return handleDynamicLinkUserActivity(application, url: userActivity.webpageURL)
	}

	public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		var handled = false
		if DynamicLinks.dynamicLinks().shouldHandleDynamicLink(fromCustomSchemeURL: url) {
			let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)
			handled = handleDynamicLink(dynamicLink)
		}
		return handled
	}

	@objc private func logEvent(notification: Notification) {
		if let userInfo = notification.userInfo, let eventName = userInfo["eventName"] as? String {
			let params = userInfo["params"] as? [String: Any]
			Analytics.logEvent(eventName, parameters: params)
		}
	}

	@objc private func setUserProperty(notification: Notification) {
		if let userInfo = notification.userInfo, let value = userInfo["value"] as? String, let name = userInfo["name"] as? String {
			Analytics.setUserProperty(value, forName: name)
		}
	}

	@objc private func reportError(notification: Notification) {
		if let userInfo = notification.userInfo, let error = userInfo["error"] as? Error {
			Crashlytics.crashlytics().record(error: error)
		}
	}

	private func handleDynamicLinkAtLaunch(_ application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
		var url = launchOptions?[.url] as? URL
		let activityKey = "UIApplicationLaunchOptionsUserActivityKey"
		if let userActivityDict = launchOptions?[.userActivityDictionary] as? NSDictionary, let userActivity = userActivityDict[activityKey] as? NSUserActivity {
			url = userActivity.webpageURL
		}
		handleDynamicLinkUserActivity(application, url: url)
	}

	@discardableResult private func handleDynamicLinkUserActivity(_ application: UIApplication, url: URL?) -> Bool {
		guard let url = url else { return false }
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			let handled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { [weak self] (dynamiclink, error) in
				if let error = error {
					print(error.localizedDescription)
					return
				}
				self?.handleDynamicLink(dynamiclink)
			}
			if !handled {
				application.open(url)
			}
		}
		return true
	}

	@discardableResult private func handleDynamicLink(_ dynamicLink: DynamicLink?) -> Bool {
		guard let dynamicLink = dynamicLink else { return false }
		if dynamicLink.matchType == .none { return false }
		guard let deepLink = dynamicLink.url else { return false }
		guard let components = URLComponents(url: deepLink, resolvingAgainstBaseURL: true) else { return false }
		guard let queryItems = components.queryItems else { return false }
		var userInfo: [String: Any] = [:]
		queryItems.forEach({ userInfo[$0.name] = $0.value })
		PersistenceManager.sharedInstance.setDeeplinkURL(deepLink.absoluteString)
		let servetureNotification = ServetureNotification(notification: userInfo, source: .deeplink)
		NotificationCenter.default.post(name: Notification.Name("DeeplinkReceived"), object: nil, userInfo: ["deeplink": servetureNotification])
		return true
	}
}
