//
//  SpacePoolAPI.swift
//  Smart Home
//
//  Created by Coder on 23/11/2023.
//

import Foundation

class SpacePoolAPI {
    
    private var farmResponse: [String: Any]!
    
    private func sendRequest() {
        let headers = [
          "accept": "application/json",
          "Developer-Key": "uHgnglDXgek8utEOiAI51E80kIUdstUZb9tOREyHDMU2zZXt7vS8HL5iDBVlrXng",
          "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://developer.pool.space/api/v1/farms/TechAdemi")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
            let httpResponse = response as? HTTPURLResponse
              do {
                  let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                  self.farmResponse = json
              } catch {
                  print("errorMsg")
              }
          }
        })

        dataTask.resume()
    }
    
    func getFarmData() -> [String: Any] {
        sendRequest()
        repeat {
            sleep(1)
        } while(farmResponse == nil)
        return farmResponse
    }
}
