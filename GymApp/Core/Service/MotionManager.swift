//
//  MotionManager.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-25.
//

import Foundation
import CoreMotion
@Observable
class MotionManager {
    
    static let shared = MotionManager()
    private var motionManager: CMMotionManager?
    var pitch: Double=0.0 //x
    var roll: Double=0.0 //y
    var yaw: Double=0.0 //z
    
    init() {
//        startDeviceMotionUpdates()
        
    }
    
    
//    func startDeviceMotionUpdates() {
//        
//        if motionManager.isDeviceMotionAvailable  {
//            
//        }
//    }
    func stopDeviceMotionUpdates() {
        motionManager?.stopDeviceMotionUpdates()
    }
}
