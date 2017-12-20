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
        
        let hostname = "localhost"
        let my_auth = [
            "client_name": "My Awesome App",
            //"client_id": "MY Client ID",
            "authorize_uri": "https://\(hostname):8081/c3pro/auth",
            "registration_uri": "https://\(hostname):8081/c3pro/register",
            "authorize_type": "client_credentials",
            ] as OAuth2JSON
        queue = DataQueue(baseURL: URL(string: "https://\(hostname):8081/c3pro/")!, auth: my_auth)
        
        //
        // DANGER ... DEBUG URL Session Delegate allows man-in-the-middle attacks (using self-signed certs or bogus Certificate Authorities).
        // using for now, because convenient for testing only.
        //
        queue.sessionDelegate = OAuth2DebugURLSessionDelegate(host: hostname)
        
        queue.logger = OAuth2DebugLogger(OAuth2LogLevel.trace)
        queue.onBeforeDynamicClientRegistration = { url in
            let registration = OAuth2DynRegAppStore()
            registration.sandbox = true
            registration.overrideAppReceipt("your apple-supplied app purchase receipt")
            registration.extraHeaders = [
                "Antispam" : "myantispam",
                ] as OAuth2StringDict
            return registration
        }
    }
}
