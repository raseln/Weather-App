//
//  Connectivity.swift
//  ProjectWinas
//
//  Created by Md. Ahsan Ullah Rasel on 16/9/19.
//  Copyright © 2019 Md. Ahsan Ullah Rasel. All rights reserved.
//

import Alamofire


struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet: Bool {
        return self.sharedInstance.isReachable
    }
}
