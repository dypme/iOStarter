//
//  LocationHelper.swift
//  iOStarter
//
//  Created by Crocodic MBP-2 on 13/08/18.
//  Copyright © 2018 WahyuAdyP. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationHelper: NSObject {
    static let shared = LocationHelper()
    
    var locationManager = CLLocationManager()
    private var locationDidUpdateAction: ((CLLocationManager) -> Void)?
    
    // Location background task property
    private var taskTimer: Timer?
    private var taskIdentifier : UIBackgroundTaskIdentifier?
    private var latestTask = Date()
    private let RESTART_TASK_DURATION = 150 // Restart location manager every 150 seconds
    private let TRIGGER_TASK_DURATION = 60 // Trigger action in background method every 60 seconds
    private var triggerTaskAction: (() -> Void)?
    
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
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /// Stop updating location
    func stop() {
        taskTimer?.invalidate()
        taskTimer = nil
        locationManager.stopUpdatingLocation()
    }
    
    /// Restart update location
    @objc func refresh() {
        stop()
        start()
    }
    
    /// Set action when location updated
    ///
    /// - Parameter action: Action for location update
    func setLocationDidUpdate(_ action: ((CLLocationManager) -> Void)?) {
        self.locationDidUpdateAction = action
    }
    
    /// Set action for every duration was set, example use for update location to server in duration
    ///
    /// - Parameter action: Action for every time duration
    func setTriggerTaskAction(_ action: (() -> Void)?) {
        self.triggerTaskAction = action
    }
    
    /// Create background task to make application can update location when in background
    private func restartBackgroundTask(){
        var prevTaskIdentifier = taskIdentifier
        taskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        if let taskIdentifier = prevTaskIdentifier {
            UIApplication.shared.endBackgroundTask(taskIdentifier)
            prevTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        }
        taskTimer = Timer.scheduledTimer(timeInterval: TimeInterval(TRIGGER_TASK_DURATION), target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
    }
    
    /// Checking duration time which has pass
    private func isTriggerTime(now: Date) -> Bool {
        let timePast = now.timeIntervalSince(latestTask)
        let intervalExceeded = Int(timePast) > TRIGGER_TASK_DURATION
        return intervalExceeded
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if manager.allowsBackgroundLocationUpdates && taskTimer == nil {
            restartBackgroundTask()
            if isTriggerTime(now: Date()) {
                triggerTaskAction?()
            }
        }
        locationDidUpdateAction?(manager)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if manager.allowsBackgroundLocationUpdates && taskTimer == nil {
            restartBackgroundTask()
        }
    }
}
