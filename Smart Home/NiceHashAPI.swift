//
//  NiceHashAPI.swift
//  Smart Home
//
//  Created by Coder on 21/11/2023.
//

import Foundation
import CryptoKit
import SwiftyNiceHash
import UserNotifications

class NiceHashAPI: ObservableObject {
    var output: NiceHashResponse.MiningRigs2?
    let api = NiceHashConnection(apiKey: "d1791e10-bc68-4c51-92fc-8d26f4f6191a", apiSecret: "b278a056-a85d-4776-a144-9d509aac16090fbf677b-31e5-4c94-9527-cf806edf131c", organizationId: "c1f94a56-81ec-45b2-bc83-ab7ac432e06f")
    
    func getData() {
        api.getRigsAndStatuses { result in
            switch result {
            case .success:
                do {
                    self.output = try result.get()
                }
                catch {
                    print(error)
                }
                
                
            case .failure:
                print("")
            }
        }
    }
    
    func getTotalDevices() -> Int {
        getData()
        while output?.totalDevices == nil {
            sleep(1)
        }
        print("API output: " + String(output!.totalDevices))
        if output!.totalDevices == 0 {
            print("Problemo")
        }
        return output!.totalDevices
    }
}
