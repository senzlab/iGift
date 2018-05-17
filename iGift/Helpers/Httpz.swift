//
//  Httpz.swift
//  iGift
//
//  Created by eranga on 5/14/18.
//  Copyright © 2018 Creative Solutions. All rights reserved.
//

import Foundation
import SwiftSocket

class Httpz {
    
    static let instance = Httpz()
    
    func doPost(url: String, param: [String : Any], onComplete: @escaping (Bool) -> ()) {
        // json
        guard let jsonData = try? JSONSerialization.data(withJSONObject: param) else {
            print("error decoding json")
            return
        }
        let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8)?
            .replacingOccurrences(of: "\\", with: "")
        
        // request data
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonStr?.data(using: .utf8)
        
        // post request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // check for errors
            guard let data = data, error == nil else {
                // request error
                print(error.debugDescription)
                onComplete(false)
                return
            }
            
            // status should be 200
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // registration fail
                print("statusCode should be 200, not \(httpStatus.statusCode)")
                onComplete(false)
                return
            }
            
            // means success
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
            
            onComplete(true)
        }
        task.resume()
    }
    
    func doGet(url: String, param: [String : Any], onComplete: @escaping (Bool, String) -> ()) {
        // json
        guard let jsonData = try? JSONSerialization.data(withJSONObject: param) else {
            print("error decoding json")
            return
        }
        let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8)?
            .replacingOccurrences(of: "\\", with: "")
        
        // request data
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = jsonStr?.data(using: .utf8)
        
        // post request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // check for errors
            guard let data = data, error == nil else {
                // request error
                print(error.debugDescription)
                onComplete(false, "")
                return
            }
            
            // status should be 200
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // registration fail
                print("statusCode should be 200, not \(httpStatus.statusCode)")
                onComplete(false, "")
                return
            }
            
            // means success
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                // get json
                // parse senz
                let msg = responseJSON["Msg"] as? String
                let senz = SenzUtil.instance.parse(msg: msg!)
                onComplete(true, senz.attr["#blob"]!)
            }
            
            onComplete(false, "")
        }
        task.resume()
    }
    
    func pushSenz(senz: String) -> String? {
        let client = TCPClient(address: "10.2.2.9", port: 7171)
        print(senz)
        switch client.connect(timeout: 10) {
        case .success:
            switch client.send(string: senz + ";") {
            case .success:
                guard let data = client.read(1024 * 10, timeout: 60) else {
                    client.close()
                    return nil
                }
                
                if let response = String(bytes: data, encoding: .utf8) {
                    print(response)
                    
                    client.close()
                    return response
                }
            case .failure(let error):
                print(error)
                
                client.close()
                return nil
            }
        case .failure(let error):
            print(error)
            
            client.close()
            return nil
        }
        
        return nil
    }
}
