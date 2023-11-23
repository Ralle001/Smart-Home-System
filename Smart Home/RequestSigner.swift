//
//  RequestSigner.swift
//  Smart Home
//
//  Created by Coder on 23/11/2023.
//

import CryptoKit
import Foundation

struct RequestSigner {
    
    struct RequestDetails {
        
        let time: Int
        let nonce: String
        let signature: String
    }
    
    let apiKey: String
    let apiSecret: String
    
    let organizationId: String
    
    init(apiKey: String, apiSecret: String, organizationId: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        
        self.organizationId = organizationId
    }
    
    func sign(method: NiceHashConnection.Method, path: String, query: String, body: String? = nil) -> RequestDetails {
        let currentTimeMS = Int(Date().timeIntervalSince1970 * 1_000)
        let nonce = UUID().uuidString
        
        let signature = sign(method: method,
                             path: path,
                             query: query,
                             body: body,
                             time: currentTimeMS,
                             nonce: nonce)
        
        return RequestDetails(time: currentTimeMS,
                              nonce: nonce,
                              signature: signature)
    }
    
    func sign(method: NiceHashConnection.Method, path: String, query: String, body: String?, time: Int, nonce: String) -> String {
        var signingInput = "\(apiKey)\u{0}\(time)\u{0}\(nonce)\u{0}\u{0}\(organizationId)\u{0}\u{0}\(method.rawValue)\u{0}\(path)\u{0}\(query)"
        
        if let b = body {
            signingInput += "\u{0}\(b)"
        }
        
        let key = SymmetricKey(data: apiSecret.data(using: .utf8)!)
        
        let signature = HMAC<SHA256>.authenticationCode(for: signingInput.data(using: .utf8)!, using: key)
        
        return Data(signature).map { String(format: "%02hhx", $0) }.joined()
    }
}
