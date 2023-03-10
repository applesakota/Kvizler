//
//  Reachability.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 2/25/23.
//

import Foundation
import SystemConfiguration

final class Reachability {
    
    /// Returns network status.
    /// - Important: This is standard implementation that can be found online.
    class var isConnectedToNetwork: Bool {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, { SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)) })!
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }

}

