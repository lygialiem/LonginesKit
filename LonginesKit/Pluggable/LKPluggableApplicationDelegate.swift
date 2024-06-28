//
//  OCDPluggableApplicationDelegate.swift
//  OCD
//
//  Created by aiden on 27/10/2023.
//
import UIKit

open class LKPluggableApplicationDelegate: UIResponder, UIApplicationDelegate {
    
    open var services: [LKPluggableApplicationDelegateService] {
        return []
    }

    public var window: UIWindow?
    
    public func applicationDidFinishLaunching(_ application: UIApplication) {
        services_.forEach { $0.applicationDidFinishLaunching?(application) }
    }

    public func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        var result = false
        for service in services_ {
            if service.application?(application, willFinishLaunchingWithOptions: launchOptions) ?? false {
                result = true
            }
        }
        return result
    }

    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        var result = false
        for service in services_ {
            if service.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? false {
                result = true
            }
        }
        return result
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        services_.forEach { $0.applicationDidBecomeActive?(application) }
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        services_.forEach { $0.applicationWillResignActive?(application) }
    }

    @available(iOS 9.0, *)
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        var result = false
        for service in services_ {
            if service.application?(app, open: url, options: options) ?? false {
                result = true
            }
        }
        return result
    }

    public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        services_.forEach { $0.applicationDidReceiveMemoryWarning?(application) }
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        services_.forEach { $0.applicationWillTerminate?(application) }
    }

    public func applicationSignificantTimeChange(_ application: UIApplication) {
        services_.forEach { $0.applicationSignificantTimeChange?(application) }
    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        services_.forEach { $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) }
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        services_.forEach { $0.application?(application, didFailToRegisterForRemoteNotificationsWithError: error) }
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        apply({ (service, completionHandler) -> Void? in
            service.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }, completionHandler: { results in
            let result = results.min(by: { $0.rawValue < $1.rawValue }) ?? .noData
            completionHandler(result)
        })
    }

    public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        apply({ (service, completionHandler) -> Void? in
            service.application?(application, handleEventsForBackgroundURLSession: identifier, completionHandler: {
                completionHandler(())
            })
        }, completionHandler: { (values: [Void]) in
            completionHandler()
        })
    }

    @available(iOS 8.2, *)
    public func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable: Any]?, reply: @escaping ([AnyHashable: Any]?) -> Void) {
        services_.forEach { $0.application?(application, handleWatchKitExtensionRequest: userInfo, reply: reply) }

        apply({ (service, reply) -> Void? in
            service.application?(application, handleWatchKitExtensionRequest: userInfo, reply: reply)
        }, completionHandler: { results in
            let result = results.reduce([:]) { initial, next in
                var initial = initial
                for (key, value) in next ?? [:] {
                    initial[key] = value
                }
                return initial
            }
            reply(result)
        })
    }

    @available(iOS 9.0, *)
    public func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        services_.forEach { $0.applicationShouldRequestHealthAuthorization?(application) }
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        services_.forEach { $0.applicationDidEnterBackground?(application) }
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        services_.forEach { $0.applicationWillEnterForeground?(application) }
    }

    public func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        services_.forEach { $0.applicationProtectedDataWillBecomeUnavailable?(application) }
    }

    public func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        services_.forEach { $0.applicationProtectedDataDidBecomeAvailable?(application) }
    }

    public func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        var result = false
        for service in services_ {
            if service.application?(application, shouldAllowExtensionPointIdentifier: extensionPointIdentifier) ?? true {
                result = true
            }
        }
        return result
    }

    public func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        for service in services_ {
            if let viewController = service.application?(application, viewControllerWithRestorationIdentifierPath: identifierComponents, coder: coder) {
                return viewController
            }
        }
        return nil
    }
    
    public func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        var result = false
        for service in services_ {
            if service.application?(application, shouldSaveSecureApplicationState: coder) ?? false {
                result = true
            }
        }
        return result
    }
    
    public func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        var result = false
        for service in services_ {
            if service.application?(application, shouldRestoreSecureApplicationState: coder) ?? false {
                result = true
            }
        }
        return result
    }

    public func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
        services_.forEach { $0.application?(application, willEncodeRestorableStateWith: coder) }
    }

    public func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
        services_.forEach { $0.application?(application, didDecodeRestorableStateWith: coder) }
    }

    public func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        var result = false
        for service in services_ {
            if service.application?(application, willContinueUserActivityWithType: userActivityType) ?? false {
                result = true
            }
        }
        return result
    }

    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let returns = apply({ (service, restorationHandler) -> Bool? in
            service.application?(application, continue: userActivity, restorationHandler: restorationHandler)
        }, completionHandler: { results in
            let result = results.reduce([]) { $0 + ($1 ?? []) }
            restorationHandler(result)
        })
        return returns.reduce(false) { $0 || $1 }
    }

    public func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        services_.forEach { $0.application?(application, didFailToContinueUserActivityWithType: userActivityType, error: error) }
    }

    public func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        services_.forEach { $0.application?(application, didUpdate: userActivity) }
    }

    #if !os(tvOS)

        @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenter requestAuthorizationWithOptions:completionHandler:]")
        public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
            services_.forEach { $0.application?(application, didRegister: notificationSettings) }
        }

        @available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
        public func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
            services_.forEach { $0.application?(application, didReceive: notification) }
        }

        @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
        public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
            apply({ (service, completion) -> Void? in
                service.application?(application, handleActionWithIdentifier: identifier, for: notification, completionHandler: {
                    completion(())
                })
            }, completionHandler: { (values: [Void]) in
                completionHandler()
            })
        }

        @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
        public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
            apply({ (service, completionHandler) -> Void? in
                service.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, withResponseInfo: responseInfo, completionHandler: {
                    completionHandler(())
                })
            }, completionHandler: { (values: [Void]) in
                completionHandler()
            })
        }

        @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
        public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
            apply({ (service, completionHandler) -> Void? in
                service.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, completionHandler: {
                    completionHandler(())
                })
            }, completionHandler: { (values: [Void]) in
                completionHandler()
            })
        }

        @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
        public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
            apply({ (service, completionHandler) -> Void? in
                service.application?(application, handleActionWithIdentifier: identifier, for: notification, withResponseInfo: responseInfo, completionHandler: {
                    completionHandler(())
                })
            }, completionHandler: { (values: [Void]) in
                completionHandler()
            })
        }

        @available(iOS 9.0, *)
        public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
            apply({ (service, completionHandler) -> Void? in
                service.application?(application, performActionFor: shortcutItem, completionHandler: completionHandler)
            }, completionHandler: { results in
                // if any service handled the shortcut, return true
                let result = results.reduce(false) { $0 || $1 }
                completionHandler(result)
            })
        }
    #endif

    /// Class's private properties.
    internal lazy var services_: [LKPluggableApplicationDelegateService] = {
        services
    }()
}

// MARK: Class's internal methods

internal extension LKPluggableApplicationDelegate {
    @discardableResult
    func apply<T, S>(_ work: (LKPluggableApplicationDelegateService, @escaping (T) -> Void) -> S?, completionHandler: @escaping ([T]) -> Void) -> [S] {
        let dispatchGroup = DispatchGroup()
        var results: [T] = []
        var returns: [S] = []

        for service in services_ {
            dispatchGroup.enter()

            let returned = work(service) { result in
                results.append(result)
                dispatchGroup.leave()
            }

            if let returned = returned {
                returns.append(returned)
            } else {
                dispatchGroup.leave()
            }

            if returned == nil {}
        }

        dispatchGroup.notify(queue: .main) {
            completionHandler(results)
        }
        return returns
    }
}

// MARK: ServiceProviderProtocol's members

extension LKPluggableApplicationDelegate: PluggableServiceProviderProtocol {
    public func queryService<S>() -> S? {
        guard services_.count > 0 else {
            return nil
        }

        findService: for s in services_ {
            guard let s = s as? S else { continue }
            return s
        }
        return nil
    }
}
