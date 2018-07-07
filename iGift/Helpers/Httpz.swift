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
    
    // contractz api
    //let api = "https://uatweb.sampath.lk/igift/v1/contractz"
    let api = "http://34.226.3.46:7171/igift/v1/contractz"
    
    func doPost(param: [String : Any], onComplete: @escaping ([Senz]) -> ()) {
        // serialize json
        guard let jsonData = try? JSONSerialization.data(withJSONObject: param) else {
            print("error decoding json")
            onComplete([])
            return
        }
        let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8)?
            .replacingOccurrences(of: "\\", with: "")
        
        // request data
        let url = URL(string: self.api)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonStr?.data(using: .utf8)
        
        // post request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // check for errors
            guard let data = data, error == nil else {
                // request error
                print(error.debugDescription)
                onComplete([])
                return
            }
            
            // status should be 200
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // registration fail
                print("statusCode should be 200, not \(httpStatus.statusCode)")
                onComplete([])
                return
            }
            
            // means success
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [Any] {
                print(responseJSON)
                
                // parse extract senzes
                var senzes: [Senz] = []
                for respDict in responseJSON {
                    if let dict = respDict as? [String: Any] {
                        let senz = SenzUtil.instance.parse(msg: (dict["Msg"] as? String)!)
                        senzes.append(senz)
                    }
                }
                
                onComplete(senzes)
                return
            }
            
            onComplete([])
        }
        
        task.resume()
    }
    
    func doGet(param: [String : Any], onComplete: @escaping ([Senz]?) -> ()) {
        // json
        guard let jsonData = try? JSONSerialization.data(withJSONObject: param) else {
            print("error decoding json")
            return
        }
        let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8)?
            .replacingOccurrences(of: "\\", with: "")
        
        // request data
        let url = URL(string: self.api)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonStr?.data(using: .utf8)
        
        // post request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // check for errors
            guard let data = data, error == nil else {
                // request error
                print(error.debugDescription)
                onComplete(nil)
                return
            }
            
            // status should be 200
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // registration fail
                print("statusCode should be 200, not \(httpStatus.statusCode)")
                onComplete(nil)
                return
            }
            
            // means success
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [Any] {
                print(responseJSON)
                
                // parse extract senzes
                var senzes: [Senz] = []
                for respDict in responseJSON {
                    if let dict = respDict as? [String: Any] {
                        let senz = SenzUtil.instance.parse(msg: (dict["Msg"] as? String)!)
                        senzes.append(senz)
                    }
                }
                
                onComplete(senzes)
            }
            
            onComplete(nil)
        }
        
        task.resume()
    }
    
    func pushSenz(senz: String) -> String? {
        var tcpUrl:String?

        #if DEBUG
            tcpUrl = "34.226.3.46"
        #else
            tcpUrl = "222.165.167.19" // sampath test
            // tcpUrl = "222.165.167.26"   // sampath prod
        #endif
        
        let client = TCPClient(address: tcpUrl!, port: 7171)
        print(senz)
        
        switch client.connect(timeout: 10) {
        case .success:
            switch client.send(string: senz + ";") {
            case .success:
                // read all data from socket
                var data = [UInt8]()
                while (true) {
                    guard let resp = client.read(1024 * 10, timeout: 60) else {
                        break
                    }
                    data += resp
                }
                
                if data.isEmpty {
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
