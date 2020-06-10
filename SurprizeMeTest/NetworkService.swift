//
//  NetworkService.swift
//  SurprizeMeTest
//
//  Created by Gamid on 09.06.2020.
//  Copyright © 2020 Gamid. All rights reserved.
//

import Alamofire

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func confirm(userId: Int, userPhone: String) {
        let url = createURL(from: API.test)
        
        let parameters: [String: Any] = ["id": userId, "phone": userPhone]
        
        AF.request(url, method: .post, parameters: parameters).validate().responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success(let value):
                guard let response = value as? [String: Any] else { return }
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func createURL(from path: String) -> URL {
        var components = URLComponents()
        components.host = API.host
        components.scheme = API.scheme
        components.path = path
        
        return components.url!
    }
    
}
