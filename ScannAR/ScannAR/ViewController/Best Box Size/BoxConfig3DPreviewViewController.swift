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
        let previewURL = URL(string: "http://www.packit4me.com/api")!
        webView?.load(URLRequest(url: previewURL))
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
