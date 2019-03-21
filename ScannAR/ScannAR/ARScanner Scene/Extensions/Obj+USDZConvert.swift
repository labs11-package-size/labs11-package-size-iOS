//
//  Obj+USDZConvert.swift
//  ScannAR
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Joshua Kaunert on 3/20/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import ModelIO

fileprivate let usdcFileExtension = "usdc"
fileprivate let usdzFileExtension = "usdz"

extension MDLAsset {
    
    public func exportToUSDZ(destinationFileUrl: URL, completionHandler: ((Bool, Error?) -> Void)? = nil) {
        // check if destinationUrl is valid
        guard FileManager.default.fileExists(atPath: destinationFileUrl.path) == false else {
            DispatchQueue.main.async {
                completionHandler?(false, nil)
            }
            return
        }
        // check if destination is ".usdz"
        guard destinationFileUrl.pathExtension == usdzFileExtension else {
            DispatchQueue.main.async {
                completionHandler?(false, nil)
            }
            return
        }
        // export the .obj asset and create a temp .usdc file
        let usdcDestinationFileUrl = destinationFileUrl.deletingPathExtension().appendingPathExtension(usdcFileExtension)
        if MDLAsset.canExportFileExtension(usdcFileExtension) {
            do {
                try self.export(to: usdcDestinationFileUrl)
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler?(false, error)
                }
            }
        } else {
            DispatchQueue.main.async {
                completionHandler?(false, nil)
            }
        }
        // rename the .usdc file to .usdz
        // for complete details see scandy's blog
        // https://www.scandy.co/blog/how-to-export-simple-3d-objects-as-usdz-on-ios
        do {
            try FileManager.default.moveItem(at: usdcDestinationFileUrl, to: destinationFileUrl)
        } catch let error {
            DispatchQueue.main.async {
                completionHandler?(false, error)
            }
        }
        
        DispatchQueue.main.async {
            completionHandler?(true, nil)
        }
    }
}
