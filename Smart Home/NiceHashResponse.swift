//
//  NiceHashResponse.swift
//  Smart Home
//
//  Created by Coder on 23/11/2023.
//

import Foundation

public enum NiceHashResponse {
    
    public enum APIError: Error {
        case decodingError
    }
    
    public struct MiningRigs2: Decodable {
        
        public struct MinerStatuses: Decodable {
            
            public let MINING: Int
        }
        
        public let minerStatuses: MinerStatuses
        public let totalRigs: Int
        public let totalProfitability: Double
        public let totalDevices: Int
    }
    
    public struct HashpowerEarnings: Decodable {
        
        public struct Entry: Decodable {
            
            public struct EnumWithDescription: Decodable {
                
                public let enumName: String
                public let description: String
            }
            
            enum CodingKeys: String, CodingKey {
                case id
                case created
                case currency
                case amount
                case accountType
                case feeAmount
            }
            
            public let id: String
            public let created: Int
            public let currency: EnumWithDescription
            public let amount: Double
            public let accountType: EnumWithDescription
            public let feeAmount: Double
            
            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                let amountAsString = try values.decode(String.self, forKey: .amount)
                
                guard let amount = Double(amountAsString) else {
                    throw APIError.decodingError
                }
                
                self.id = try values.decode(String.self, forKey: .id)
                self.created = try values.decode(Int.self, forKey: .created)
                self.currency = try values.decode(EnumWithDescription.self, forKey: .currency)
                self.amount = amount
                self.accountType = try values.decode(EnumWithDescription.self, forKey: .accountType)
                self.feeAmount = try values.decode(Double.self, forKey: .feeAmount)
            }
        }
        
        public let list: [Entry]
    }
}
