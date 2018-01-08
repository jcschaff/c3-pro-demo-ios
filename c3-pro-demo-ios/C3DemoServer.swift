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
    
    class C3DemoQueueDelegate: EncryptedDataQueueDelegate {
        var key_id: String
        init(key_id: String){
            self.key_id = key_id
        }
        func encryptedDataQueue(_ queue: EncryptedDataQueue, wantsEncryptionForResource resource: Resource, requestMethod: FHIRRequestMethod) -> Bool {
            return true
        }
        
        func keyIdentifierForEncryptedDataQueue(_ queue: EncryptedDataQueue) -> String? {
            return key_id
        }
    }

    var queue: EncryptedDataQueue
    var delegate: C3DemoQueueDelegate

    init() {
        //super.init()
        let baseurl_auth = "https://api.jcschaff.net:8888/c3pro"
        //let baseurl_auth = "https://2amoveu7z2.execute-api.us-east-1.amazonaws.com/alpha/c3pro"
        //let baseurl_auth = "https://api.jcschaff.net/c3pro/alpha/c3pro"
        let baseurl_api = "https://api.jcschaff.net:8889/c3pro"
        //let baseurl_api = "https://2amoveu7z2.execute-api.us-east-1.amazonaws.com/alpha/c3pro"
        //let baseurl_api = "https://api.jcschaff.net/c3pro/alpha/c3pro"
        let my_auth = [
            "client_name": "My Awesome App",
            //"client_id": "MY Client ID",
            "authorize_uri": "\(baseurl_auth)/auth",
            "registration_uri": "\(baseurl_auth)/register",
            "authorize_type": "client_credentials",
            ] as OAuth2JSON
        // encBaseURL: URL, publicCertificateFile: String
        
        // this cert file should be "bundled" with the app????
        //let certFile = "/Users/schaff/.c3pro/iOS/public"
        let certFile = "public"
        
        queue = EncryptedDataQueue(baseURL: URL(string: "\(baseurl_api)/")!,
                                   auth: my_auth,
                                   encBaseURL: URL(string: "\(baseurl_api)/fhirenc/")!,
                                   publicCertificateFile: certFile)
        
        
        delegate = C3DemoQueueDelegate(key_id: "public_key_id")
        queue.delegate = delegate
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
        queue.ready(callback: { (error: FHIRError?) in
            if let e = error {
                print(e)
            }
            return
        })
//        queue.registerIfNeeded(callback:{ (oauth: OAuth2JSON?, error: Error?) in
//            if let o = oauth {
//                print(o)
//            }
//            if let e = error {
//                print(e)
//            }
//            return
//        })
    }
}
