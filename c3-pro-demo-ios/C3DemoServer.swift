//
//  C3DemoServer.swift
//  c3-pro-demo-ios
//
//  Created by James Schaff on 12/19/17.
//  Copyright © 2017 Boston Children's Hospital. All rights reserved.
//

import Foundation
//
//  C3PROTests.swift
//  C3PROTests
//
//  Created by Pascal Pfiffner on 4/20/15.
//  Copyright (c) 2015 Boston Children's Hospital. All rights reserved.
//

import UIKit
import C3PRO
import SMART

final class C3DemoServer {
    
    static let sharedInstance: C3DemoServer = {
        let instance = C3DemoServer()
        return instance
    }()
    
    var queue: DataQueue

    init() {
        //super.init()
        //let hostname = "jamess-mbp-2.j4home.net"
        //let hostname = "jamess-mbp-2.local"
        //let hostname = "Jamess-MacBook-Pro-2.local"
        
        let baseurl = "https://api.jcschaff.net:8888"
        //let baseurl = "https://2amoveu7z2.execute-api.us-east-1.amazonaws.com/alpha"
        //let baseurl = "https://api.jcschaff.net/c3pro/alpha"
        let my_auth = [
            "client_name": "My Awesome App",
            //"client_id": "MY Client ID",
            "authorize_uri": "\(baseurl)/auth",
            "registration_uri": "\(baseurl)/register",
            "authorize_type": "client_credentials",
            ] as OAuth2JSON
        queue = DataQueue(baseURL: URL(string: "\(baseurl)/")!, auth: my_auth)
        
//        //
//        // DANGER ... DEBUG URL Session Delegate allows man-in-the-middle attacks (using self-signed certs or bogus Certificate Authorities).
//        // using for now, because convenient for testing only.
//        //
//        queue.sessionDelegate = OAuth2DebugURLSessionDelegate(host: hostname)
        
        queue.logger = OAuth2DebugLogger(OAuth2LogLevel.trace)
        queue.onBeforeDynamicClientRegistration = { url in
            let registration = OAuth2DynRegAppStore()
            registration.sandbox = true
            registration.overrideAppReceipt("NO-APP-RECEIPT")
            registration.extraHeaders = [
                "Antispam" : "myantispam",
                ] as OAuth2StringDict
            return registration
        }
    }
}
