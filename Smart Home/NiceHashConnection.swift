//
//  NiceHashConnection.swift
//  Smart Home
//
//  Created by Coder on 23/11/2023.
//

import CryptoKit
import Foundation

public class NiceHashConnection {
    
    public enum NiceHashError: Error {
        
        case invalidResponse
    }
    
    public enum Method: String {
        
        case GET = "GET"
        case POST = "POST"
    }
    
    static private let Endpoint = "https://api2.nicehash.com"
    
    private let apiKey: String
    private let apiSecret: String
    
    private let organizationId: String
    
    private let requestSigner: RequestSigner
    
    public init(apiKey: String, apiSecret: String, organizationId: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        
        self.organizationId = organizationId
        
        self.requestSigner = RequestSigner(apiKey: apiKey, apiSecret: apiSecret, organizationId: organizationId)
    }
    
    private func performCall<T: Decodable>(withPath path: String, method: Method, queryString: String, completionHandler: @escaping (Result<T, NiceHashConnection.NiceHashError>) -> ()) {
        let requestDetails = requestSigner.sign(method: method, path: path, query: queryString)
        
        let url = URL(string: "\(NiceHashConnection.Endpoint)\(path)?\(queryString)")!
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.addValue("\(requestDetails.time)", forHTTPHeaderField: "X-Time")
        urlRequest.addValue(requestDetails.nonce, forHTTPHeaderField: "X-Nonce")
        urlRequest.addValue(organizationId, forHTTPHeaderField: "X-Organization-Id")
        urlRequest.addValue("\(apiKey):\(requestDetails.signature)", forHTTPHeaderField: "X-Auth")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil, let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.invalidResponse))
                
                return
            }
            
            if response.statusCode == 403 || response.statusCode == 500 {
                completionHandler(.failure(.invalidResponse))
                
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidResponse))
                
                return
            }
            
            guard let parsedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(.failure(.invalidResponse))

                return
            }

            completionHandler(.success(parsedResponse))
        }
        
        task.resume()
    }
    
    public func getRigsAndStatuses(completionHandler: @escaping (Result<NiceHashResponse.MiningRigs2, NiceHashConnection.NiceHashError>) -> ()) {
        performCall(withPath: "/main/api/v2/mining/rigs2", method: .GET, queryString: "") { (result: Result<NiceHashResponse.MiningRigs2, NiceHashConnection.NiceHashError>) in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getHashpowerEarnings(currency: String, completionHandler: @escaping (Result<[NiceHashResponse.HashpowerEarnings.Entry], NiceHashConnection.NiceHashError>) -> ()) {
        performCall(withPath: "/main/api/v2/accounting/hashpowerEarnings/\(currency)", method: .GET, queryString: "") { (result: Result<NiceHashResponse.HashpowerEarnings, NiceHashConnection.NiceHashError>) in
            switch result {
            case .success(let response):
                completionHandler(.success(response.list))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

