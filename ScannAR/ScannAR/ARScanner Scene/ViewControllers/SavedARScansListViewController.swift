//
//  SavedARScansListViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/22/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import UIKit

class SavedARScansListViewController: UIViewController {
    
    @IBOutlet weak var cancelObjectPickerButton: UIBarButtonItem!
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        let transition: CATransition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    static let aRObjectPathExtension = "arobject"
    //    static let kPng = "png"
    var arrObjectName:[String] = []
    var arrObjectURL :[[String:URL]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllStoredObjectModelFromDirectory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func getAllStoredObjectModelFromDirectory() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            let arobjectFiles = directoryContents.filter{ $0.pathExtension == SavedARScansListViewController.aRObjectPathExtension }
            
            print("arobject urls:",arobjectFiles)
            let fileName = arobjectFiles.map{ $0.deletingPathExtension().lastPathComponent }
            print("object Name list:", fileName)
            for arobject in arobjectFiles {
                arrObjectURL.append([SavedARScansListViewController.aRObjectPathExtension:arobject])
            }
            arrObjectName = fileName
            if arrObjectName.count == 0 {
                // FIXME: -  to an alertcontroller LAZY!
                DispatchQueue.main.async {
                    self.tableView.setBackgroundText(stringValue: "There is no Scanned/Saved objects available. \n Please Scan and Save Object from Scan New Object Section.")
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.removeBackgroundText()
                    self.tableView.reloadData()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension SavedARScansListViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrObjectName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arobjectListCell")
        let label = cell?.viewWithTag(42) as? UILabel
        label?.text = arrObjectName[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ARDetectViewController") as! ARDetectViewController
        if arrObjectURL[indexPath.row].keys.first == SavedARScansListViewController.aRObjectPathExtension {
            vc.objectURL = arrObjectURL[indexPath.row][SavedARScansListViewController.aRObjectPathExtension]
        } else {
            //
        }
        
        
        let transition: CATransition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController!.view.layer.add(transition, forKey: nil)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("more button tapped")
            let fileManager = FileManager.default
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            guard let dirPath = paths.first else {
                return
            }
            var filename = ""
            filename = "\(self.arrObjectName[indexPath.row]).\(SavedARScansListViewController.aRObjectPathExtension)"
            
            let filePath = "\(dirPath)/\(filename)"
            do {
                try fileManager.removeItem(atPath: filePath)
                self.arrObjectName.remove(at: indexPath.row)
                self.arrObjectURL.remove(at: indexPath.row)
                self.tableView.reloadData()
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
        delete.backgroundColor = .appBrown
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
extension UITableView {
    
    func setBackgroundText(stringValue:String) {
        let backgroundLabel = UILabel()
        backgroundLabel.font = UIFont.systemFont(ofSize: 21)
        backgroundLabel.textColor = .black
        backgroundLabel.numberOfLines = 0
        
        backgroundLabel.textAlignment = .center
        backgroundLabel.text = stringValue
        
        backgroundLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundLabel.translatesAutoresizingMaskIntoConstraints = true
        
        self.backgroundView = backgroundLabel
    }
    
    func removeBackgroundText() {
        self.backgroundView = nil
    }
}
