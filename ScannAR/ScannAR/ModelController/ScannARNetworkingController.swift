//
//  ScannARNetworkingController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/20/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation

class ScannARNetworkController {

    // to be refactored later
    let baseURL = "https://scannarserver.herokuapp.com"
    
    /*
     Get an Authentication Token With a dictionary of a username and password
    */
    func getAuthenticationToken(dict: [String: String], completion: @escaping (String?, Error?) -> Void) {

        let urlComponents = URLComponents(string: baseURL)
        guard var path = urlComponents?.path else { fatalError("URL Compents should have url path but does not")}
        
        path = "\(baseURL)/api/users/login"
        
        guard let url = URL(string: path)
            else {
                fatalError("Unable to construct baseURL")
        }
        
        var jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dict)
            
        } catch {
            print("failed to convert dictionary to json")
            return
        }

        // Create a GET request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Asynchronously fetch data
        // Once the fetch completes, it calls its handler either with data
        // (if available) _or_ with an error (if one happened)
        // There's also a URL Response but we're going to ignore it
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Rehydrate our data by unwrapping it
            guard error == nil, let data = data else {
                if let error = error { // this will always succeed
                    NSLog("Error fetching data: \(error)")
                    completion(nil, error) // we know that error is non-nil
                }
                return
            }

            // We know now we have no error *and* we have data to work with
            do {
                // Declare, customize, use the decoder
                let jsonDecoder = JSONDecoder()

                let result = try jsonDecoder.decode(JSONWebToken.self, from: data)
                self.jsonToken = result

                // Send back the results to the completion handler
                completion(nil, nil)

            } catch {
                NSLog("Unable to decode data into search: \(error)")
                completion(nil, error)
                //        return
            }
        }
        dataTask.resume()
    }
    
    
    /*
     Get an Authentication Token With a dictionary of a username and password
     */
    func getProducts(completion: @escaping ([ProductRepresentation]?, Error?) -> Void) {
        
        let urlComponents = URLComponents(string: baseURL)
        guard var path = urlComponents?.path else { fatalError("URL Compents should have url path but does not")}
        
        path = "\(baseURL)/api/products"
        
        guard let url = URL(string: path)
            else {
                fatalError("Unable to construct baseURL")
        }
        
        guard let jsonToken = jsonToken else {
            fatalError("The jsonToken is empty.")
        }
        
        // Create a GET request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
        
        // Asynchronously fetch data
        // Once the fetch completes, it calls its handler either with data
        // (if available) _or_ with an error (if one happened)
        // There's also a URL Response but we're going to ignore it
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Rehydrate our data by unwrapping it
            guard error == nil, let data = data else {
                if let error = error { // this will always succeed
                    NSLog("Error fetching data: \(error)")
                    completion(nil, error) // we know that error is non-nil
                }
                return
            }
            
            // We know now we have no error *and* we have data to work with
            do {
                // Declare, customize, use the decoder
                let jsonDecoder = JSONDecoder()
                
                let result = try jsonDecoder.decode(ProductsResult.self, from: data)
                
                // Send back the results to the completion handler
                completion(nil, nil)
                
            } catch {
                NSLog("Unable to decode data into search: \(error)")
                completion(nil, error)
                //        return
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Properties
    private var jsonToken: JSONWebToken?
    var productRepresentations: [ProductRepresentation]?

}
