//
//  ScannARNetworkingController.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 3/20/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import CoreData

class ScannARNetworkController {

    // MARK: - Private Methods
    static let shared = ScannARNetworkController()
    private init (){}
    /*
     Generic apiRequest
     */
    private func apiRequest<T: Codable>(from urlRequest: URLRequest,
                                        using session: URLSession = URLSession.shared,
                                        completion: @escaping (T?, Error?) -> Void) {
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "com.lambdaSchool.ErrorDomain", code: -1, userInfo: nil))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedObject = try jsonDecoder.decode(T.self, from: data)
                completion(decodedObject, nil)
            } catch {
                print("Error:\(error)")
                completion(nil, error)
            }
            }.resume()
    }
    
    // MARK: - Login & Authentication Networking
    
    /*
     Post a username & password to get an Authentication Token
    */
    func postForAuthenticationToken(dict: [String: String], completion: @escaping (JSONWebToken?, Error?) -> Void) {
        
        let request = createRequest(for: .POSTWebToken, with: dict)
        
        apiRequest(from: request) { (results: JSONWebToken?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            
            guard let results = results else {
                return completion(nil, nil)
            }
            self.jsonToken = results
            completion(results, nil)
        }
        
    }
    
    /*
     Get Validation that the current user token is correct
     */
    func getValidationOfToken(completion: @escaping (Bool?, Error?) -> Void) {
        
        let request = createRequest(for: .GETValidateToken)
        
        apiRequest(from: request) { (results: Bool?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            
            completion(results, nil)
        }
        
    }
    
    /*
     POST a new user
     */
    func postNewUser(completion: @escaping (Bool?, Error?) -> Void) {
        
        let request = createRequest(for: .POSTRegisterNewUser)
        
        apiRequest(from: request) { (results: Bool?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            
            completion(results, nil)
        }
        
    }
    
    /*
     GET user account information
     */
    func getUserAccountInfo(completion: @escaping (Account?, Error?) -> Void) {
        
        let request = createRequest(for: .GETAccountInfo)
        
        apiRequest(from: request) { (results: Account?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            
            completion(results, nil)
        }
        
    }
    
    /*
     GET user account information
     */
    func putEditUserAccountInfo(dict: [String: String], completion: @escaping (Account?, Error?) -> Void) {

        let request = createRequest(for: .PUTEditAccountInfo, with: dict)

        apiRequest(from: request) { (results: Account?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            
            completion(results, nil)
        }

    }
    
    
    // MARK: - Product Networking

    /*
     Get an list of Products for jsonToken representing the User
     */
    func getProducts(completion: @escaping ([ProductRepresentation]?, Error?) -> Void) {
        
        let request = createRequest(for: .GETProducts)
        
        apiRequest(from: request) { (results: [ProductRepresentation]?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            
            guard let results = results else {
                return completion(nil, nil)
            }
            let moc = CoreDataStack.shared.container.newBackgroundContext()
            
            var tempProducts: [Product] = []
            for result in results {
                let newProduct = Product(productRepresentation: result, context: moc)
                tempProducts.append(newProduct)
            }
            self.products = tempProducts
            
            completion(results, nil)
        }
    }
    
    /*
     POST New Products for jsonToken representing the User
     */
    func postNewProduct(dict: [String: String], completion: @escaping ([ProductRepresentation]?, Error?) -> Void) {
        
        let request = createRequest(for: .POSTNewProduct, with: dict)
        
        apiRequest(from: request) { (results: [ProductRepresentation]?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            
            completion(results, nil)
        }
    }
    
    /*
     DELETE Product for jsonToken representing the User, for a UUID
     */
    func deleteProduct(uuid: UUID, completion: @escaping (Error?) -> Void) {
        
        let request = createRequest(for: .DELETEProduct, for: uuid)
        
        apiRequest(from: request) { (results: [ProductRepresentation]?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    /*
     EDIT Product for jsonToken representing the User, for a UUID
     */
    func putEditProduct(dict: [String: String], uuid: UUID, completion: @escaping (Error?) -> Void) {
        
        let request = createRequest(for: .PUTEditProduct, with: dict, for: uuid)
        
        apiRequest(from: request) { (results: [ProductRepresentation]?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    /*
     Get an list of all assets associated with a product
     */
    func getAssetsForProduct(uuid: UUID, completion: @escaping ([ProductAsset]?, Error?) -> Void) {
        
        let request = createRequest(for: .GETProductsAssets, for: uuid)
        
        apiRequest(from: request) { (results: [ProductAsset]?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            
            guard let results = results else {
                return completion(nil, nil)
            }
            
            completion(results, nil)
        }
    }
    
    /*
     POST a new asset for a given product
     */
    func postNewAssetsForProduct(dict: [String: String], uuid: UUID, completion: @escaping ( Error?) -> Void) {
        
        let request = createRequest(for: .POSTProductAsset, with: dict, for: uuid)
        
        apiRequest(from: request) { (results: [ProductAsset]?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    
    // MARK: - Shipment Networking Methods
    
    /*
     Get an list of Shipments for jsonToken representing the User
     */
    func getShipments(completion: @escaping ([ShipmentRepresentation]?, Error?) -> Void) {
        
        let request = createRequest(for: .GETShipments)
        
        apiRequest(from: request) { (results: [ShipmentRepresentation]?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            
            guard let results = results else {
                return completion(nil, nil)
            }
            let moc = CoreDataStack.shared.container.newBackgroundContext()
            
            var tempShipments: [Shipment] = []
            for result in results {
                let newShipment = Shipment(shipmentRepresentation: result, context: moc)
                tempShipments.append(newShipment)
            }
            self.shipments = tempShipments
            
            completion(results, nil)
        }
    }
    
    /*
     Post a new Shipment using a USPS Tracking Number for jsonToken representing the User
     */
    func postNewShipment(dict: [String: String], completion: @escaping (Error?) -> Void) {
        
        let request = createRequest(for: .POSTNewShipment, with: dict)
        
        apiRequest(from: request) { (_ results: [ShipmentRepresentation]?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    /*
     Delete a Shipment with a given UUID for a jsonToken representing the User
     */
    func deleteShipment(uuid: UUID, completion: @escaping ([ShipmentRepresentation]?, Error?) -> Void) {
        
        let request = createRequest(for: .DELETEShipment, for: uuid)
        
        apiRequest(from: request) { (_ results: [ShipmentRepresentation]?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil,error)
            }
            
            completion(results, nil)
        }
    }
    
    /*
     Post edit a Shipment with a given UUID for a jsonToken representing the User
     */
    func postNewShipment(dict: [String: String], uuid: UUID, completion: @escaping (Error?) -> Void) {
        
        let request = createRequest(for: .PUTEditShipment, with: dict, for: uuid)
        
        apiRequest(from: request) { (_ results: [ShipmentRepresentation]?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(error)
            }
            
            completion(nil)
        }
    }
    
    // MARK: - Packaging Networking Methods
    /*
     Post an array of Products to get a preview of potential packaging options for the products
     */
    func postPackagingPreview(packagingDict: PackagePreviewRequest, completion: @escaping ([PackageConfiguration]? ,Error?) -> Void) {
        
        let request = createRequest(for: .POSTPreviewPackaging, using: packagingDict)
        
        apiRequest(from: request) { (_ results: [PackageConfiguration]?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            
            completion(results, nil)
        }
    }
    
    /*
     Post an array of Packaging Configurations (possibly just one) that you want to save as packages.
     */
    func postAddPackages(packagingConfigurations: [PackageConfiguration], completion: @escaping ([PackageConfiguration]? ,Error?) -> Void) {
        
        let request = createRequest(for: .POSTPreviewPackaging, packagingConfigurations: packagingConfigurations)
        
        apiRequest(from: request) { (_ results: [PackageConfiguration]?, error: Error?) in
            
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            
            completion(results, nil)
        }
    }
    
    
    // MARK: - Properties
    
    let baseURL = URL(string:"https://scannarserver.herokuapp.com/api")!
    private var jsonToken: JSONWebToken?
    var products: [Product] = []
    var shipments: [Shipment] = []

}

extension ScannARNetworkController {
    
    // URLRequest Creation
    func createRequest(for apiCallType: APICallType, with dict: [String:String]? = nil, using packagingDict: PackagePreviewRequest? = nil, packagingConfigurations: [PackageConfiguration]? = nil, for uuid: UUID? = nil) -> URLRequest {
        
        switch apiCallType {
        
        // login & Auth
        case .POSTRegisterNewUser:
            
            // TODO: - Finish implementing
            var url = baseURL
            url = url.appendingPathComponent("users")
            url = url.appendingPathComponent("register")
            
            var jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: dict!)
            } catch {
                print("failed to convert dictionary to json")
                fatalError("")
            }
            
            // Create a POST request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            return request
            
        
        case .POSTWebToken:
            
            var url = baseURL
            url = url.appendingPathComponent("users")
            url = url.appendingPathComponent("login")
            
            var jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: dict!)
            } catch {
                print("failed to convert dictionary to json")
                fatalError("")
            }
            
            // Create a POST request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            return request
        
        case .GETValidateToken:
            
            var url = baseURL
            url = url.appendingPathComponent("users")
            url = url.appendingPathComponent("checkauth")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            // Create a GET request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.GET.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            
            return request
        
        // account info
        case .GETAccountInfo:
            var url = baseURL
            url = url.appendingPathComponent("users")
            url = url.appendingPathComponent("accountinfo")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            // Create a GET request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.GET.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            
            return request
            
        case .PUTEditAccountInfo:
            var url = baseURL
            url = url.appendingPathComponent("products")
            url = url.appendingPathComponent("edit")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            var jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: dict!)
            } catch {
                print("failed to convert dictionary to json")
                fatalError("")
            }
            
            // Create a PUT request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.PUT.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            return request
            
        // products
        case .GETProducts:
            
            var url = baseURL
            url = url.appendingPathComponent("products")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            // Create a GET request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.GET.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            
            return request
        
        case .POSTNewProduct:
            var url = baseURL
            url = url.appendingPathComponent("products")
            url = url.appendingPathComponent("add")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            var jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: dict!)
            } catch {
                print("failed to convert dictionary to json")
                fatalError("")
            }

            // Create a POST request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            return request
            
        case .DELETEProduct:
            
            guard let uuid = uuid else { fatalError("no UUID passed") }
            var url = baseURL
            url = url.appendingPathComponent("products")
            url = url.appendingPathComponent("delete")
            url = url.appendingPathComponent("\(uuid.uuidString)")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            // Create a DELETE request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.DELETE.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            
            return request
            
        case .PUTEditProduct:
            guard let uuid = uuid else { fatalError("no UUID passed") }
            var url = baseURL
            url = url.appendingPathComponent("products")
            url = url.appendingPathComponent("edit")
            url = url.appendingPathComponent("\(uuid.uuidString)")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            var jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: dict!)
            } catch {
                print("failed to convert dictionary to json")
                fatalError("")
            }
            
            // Create a PUT request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.PUT.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            return request
            
        case .GETProductsAssets:
            guard let uuid = uuid else { fatalError("no UUID passed") }
            var url = baseURL
            url = url.appendingPathComponent("products")
            url = url.appendingPathComponent("assets")
            url = url.appendingPathComponent("\(uuid.uuidString)")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            // Create a GET request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.GET.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            
            return request
            
        case .POSTProductAsset:
            guard let uuid = uuid else { fatalError("no UUID passed") }
            var url = baseURL
            url = url.appendingPathComponent("products")
            url = url.appendingPathComponent("assets")
            url = url.appendingPathComponent("add")
            url = url.appendingPathComponent("\(uuid.uuidString)")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            var jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: dict!)
            } catch {
                print("failed to convert dictionary to json")
                fatalError("")
            }
            
            // Create a POST request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            return request
        
        // shipments
        case .GETShipments :
            
            var url = baseURL
            url = url.appendingPathComponent("shipments")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            // Create a GET request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.GET.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            
            return request

        case .POSTNewShipment:
            var url = baseURL
            url = url.appendingPathComponent("shipments")
            url = url.appendingPathComponent("add")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            var jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: dict!)
            } catch {
                print("failed to convert dictionary to json")
                fatalError("")
            }
            
            // Create a POST request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            return request
            
        case .DELETEShipment:
            guard let uuid = uuid else { fatalError("no UUID passed") }
            var url = baseURL
            url = url.appendingPathComponent("shipments")
            url = url.appendingPathComponent("delete")
            url = url.appendingPathComponent("\(uuid.uuidString)")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            // Create a DELETE request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.DELETE.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            
            return request
            
        case .PUTEditShipment:
            guard let uuid = uuid else { fatalError("no UUID passed") }
            var url = baseURL
            url = url.appendingPathComponent("shipments")
            url = url.appendingPathComponent("edit")
            url = url.appendingPathComponent("\(uuid.uuidString)")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            var jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: dict!)
            } catch {
                print("failed to convert dictionary to json")
                fatalError("")
            }
            
            // Create a PUT request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.PUT.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            return request
            
        case .POSTPreviewPackaging:
            
            guard let packagingDict = packagingDict else { fatalError("no packaging Dictionary passed") }
            var url = baseURL
            url = url.appendingPathComponent("packaging")
            url = url.appendingPathComponent("preview")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            var jsonData: Data
            do {
                let jsonEncoder = JSONEncoder()
                jsonData = try jsonEncoder.encode(packagingDict)
                print(jsonData)
            } catch {
                print("failed to convert dictionary to json")
                fatalError("")
            }
            
            // Create a POST request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            return request
            
        case .POSTAddPackage:
            
            guard let packagingConfigurations = packagingConfigurations else { fatalError("no packaging Dictionary passed") }
            var url = baseURL
            url = url.appendingPathComponent("packages")
            url = url.appendingPathComponent("add")
            
            guard let jsonToken = jsonToken else { fatalError("The jsonToken is empty.") }
            
            var jsonData: Data
            do {
                jsonData = try JSONSerialization.data(withJSONObject: packagingConfigurations)
            } catch {
                print("failed to convert array of packagingConfigurations to json")
                fatalError("failed to convert array of packagingConfigurations to json")
            }
            
            // Create a POST request
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.POST.rawValue
            request.addValue(jsonToken.token, forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            return request
        }
        
    }
}
