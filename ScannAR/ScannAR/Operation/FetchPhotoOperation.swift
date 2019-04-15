//
//  FetchPhotoOperation.swift
//  ScannAR
//
//  Created by Benjamin Hakes on 4/10/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class FetchPhotoOperation: ConcurrentOperation {
    
    init(photoReference: Product, session: URLSession = URLSession.shared) {
        self.photoReference = photoReference
        self.session = session
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        guard let url = photoReference.thumbnail?.usingHTTPS! else { return }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for \(self.photoReference): \(error)")
                return
            }
            
            if let data = data {
                self.image = UIImage(data: data)
            }
        }
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
    // MARK: Properties
    
    let photoReference: Product
    
    private let session: URLSession
    
    private(set) var image: UIImage?
    
    private var dataTask: URLSessionDataTask?
}

