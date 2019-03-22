//
//  ScannARNetworkingController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/20/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

class ScannARNetworkController {
//    
//    // to be refactored later
//    let baseURL = "https://scannar-be.herokuapp.com/api/users/login"
//    let dictionary<String,String> = ["username": "ben",
//                      "password": "hakes"]
//    let json = try JSONEncoder.encode()
//    let dataFromDictionary = Data(
//
//    // Add the completion last
//    func getFromHeroku(completion: @escaping (String?, Error?) -> Void) {
//        
//        // Establish the base url for our search
//        guard let baseURL = URL(string: baseURL)
//            else {
//                fatalError("Unable to construct baseURL")
//        }
//        
//        // Decompose it into its components
////        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
////            fatalError("Unable to resolve baseURL to components")
////        }
//        
//        
//        // Create a GET request
//        var request = URLRequest(url: baseURL)
//        request.httpMethod = "POST" // basically "READ"
//        
//        request.httpBody =
//        
//        
//        // Asynchronously fetch data
//        // Once the fetch completes, it calls its handler either with data
//        // (if available) _or_ with an error (if one happened)
//        // There's also a URL Response but we're going to ignore it
//        let dataTask = URLSession.shared.dataTask(with: request) {
//            // This closure is sent three parameters:
//            data, _, error in
//            
//            // Rehydrate our data by unwrapping it
//            guard error == nil, let data = data else {
//                if let error = error { // this will always succeed
//                    NSLog("Error fetching data: \(error)")
//                    completion(nil, error) // we know that error is non-nil
//                }
//                return
//            }
//            
//            // We know now we have no error *and* we have data to work with
//            
//            // Convert the data to JSON
//            // We need to convert snake_case decoding to camelCase
//            // Oddly there is no kebab-case equivalent
//            // Note issues with naming and show similar thing
//            do {
//                // Declare, customize, use the decoder
//                let jsonDecoder = JSONDecoder()
//                
//                let results = try jsonDecoder.decode(String.self, from: data)
//                
//                // Send back the results to the completion handler
//                completion(results, nil)
//                
//            } catch {
//                NSLog("Unable to decode data into search: \(error)")
//                completion(nil, error)
//                //        return
//            }
//        }
//        
//        // A data task needs to be run. To start it, you call `resume`.
//        // "Newly-initialized tasks begin in a suspended state, so you need to call this method to start the task."
//        dataTask.resume()
//    }
//    
}
