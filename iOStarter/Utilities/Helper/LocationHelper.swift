//
//  LocationHelper.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 13/08/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHelper: NSObject {
    static let shared = LocationHelper()
    
    private let BACKGROUND_TIMER = 150 // restart location manager every 150 seconds
    private let UPDATE_DURATION = 60 // 1 minute - once every 1 minute send location to server
    
    var isBackgroundUpdate = false
    
    var locationManager: CLLocationManager = CLLocationManager()
    private var timer: Timer?
    private var currentBgTaskId : UIBackgroundTaskIdentifier?
    private var lastLocationDate = Date()
    
    private var updateAction: ((CLLocationManager) -> Void)?
    private var updateDataInTimeAction: (() -> Void)?
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterBackground), name: UIApplication.willTerminateNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
    }
    
    /// Call action when application enter to background or application not use
    @objc private func applicationEnterBackground(){
        
    }
    
    /// Call action when application active ready to use
    @objc private func applicationBecomeActive(){
        
    }
    
    /// Start updating location, location always updating after you start in every view, so if you want to update location in specific view don't forget call stop function
    func start() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /// Stop updating location
    func stop() {
        timer?.invalidate()
        timer = nil
        locationManager.stopUpdatingLocation()
    }
    
    /// Restart update location
    @objc func refresh() {
        stop()
        start()
    }
    
    /// Check permission of location use for this application
    func checkLocationPermission() {
        if UserSession.shared.isUserLoggedIn {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways:
                    break
                case .authorizedWhenInUse:
                    break
                case .denied:
                    break
                case .notDetermined:
                    print("Not determined")
                case .restricted:
                    print("Restricted")
                default:
                    break
                }
            }
        }
    }
    
    /// Show alert to open setting permission of application
    ///
    /// - Parameters:
    ///   - title: Title of alert permission
    ///   - message: Message information of alert
    private func permissionAlert(title: String? = nil, message: String) {
        let vc = AppDelegate.shared.window?.rootViewController
        vc?.simpleAlert(title: title, message: message, handler: { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        })
    }
    
    /// Set action when location updated
    ///
    /// - Parameter action: Action for location update
    func setUpdateLocation(_ action: ((CLLocationManager) -> Void)?) {
        self.updateAction = action
    }
    
    /// Set action for every duration was set, example use for update location to server in duration
    ///
    /// - Parameter action: Action for every time duration
    func setUpdateDataInTime(_ action: (() -> Void)?) {
        self.updateDataInTimeAction = action
    }
    
    /// Update data when for every duration
    func updateData() {
        updateDataInTimeAction?()
    }
    
    /// Create background task to make application can update location when in background
    private func beginNewBackgroundTask(){
        var previousTaskId = currentBgTaskId
        
        if isBackgroundUpdate {
            currentBgTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                print("Task expired")
            })
            if let taskId = previousTaskId {
                UIApplication.shared.endBackgroundTask(taskId)
                previousTaskId = UIBackgroundTaskIdentifier.invalid
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(UPDATE_DURATION), target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
    }
    
    /// Checking duration time which has pass
    ///
    /// - Parameter now: Current time
    /// - Returns: Is this time
    private func isItTime(now: Date) -> Bool {
        let timePast = now.timeIntervalSince(lastLocationDate)
        let intervalExceeded = Int(timePast) > UPDATE_DURATION
        return intervalExceeded
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if timer == nil {
            beginNewBackgroundTask()
            
            let now = Date()
            if isItTime(now: now) {
                updateData()
            }
            
            guard let location = manager.location else {
                return
            }
            if UIApplication.shared.applicationState != .active {
                print("App in background. New location is \(location)")
            }
        }
        updateAction?(manager)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if timer == nil {
            beginNewBackgroundTask()
        }
    }
}
