//
//  3DBoxConfigPreviewViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 4/4/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import WebKit
import UIKit

class BoxConfig3DPreviewViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let previewURL = URL(string: "http://www.packit4me.com/api/call/preview?bins=0:50:5x5x5&items=0:0:5:1x2x3,1:0:10:2x4x2&binId=0")!
        var request = URLRequest(url: previewURL)
        request.httpMethod = "POST"
        webView?.load(request)
        webView.allowsBackForwardNavigationGestures = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
