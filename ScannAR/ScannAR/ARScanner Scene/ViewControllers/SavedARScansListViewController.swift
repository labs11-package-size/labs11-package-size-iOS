//
//  SavedARScansListViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/22/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

class SavedARScansListViewController: UIViewController {
    
   
    @IBOutlet weak var tableView: UITableView!
    static let kArObject = "arobject"
    var arrObjectName:[String] = []
    var arrObjectURL :[[String:URL]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllStoredObjectModelFromDirectory()
        // Do any additional setup after loading the view.
    }
    
    
    func getAllStoredObjectModelFromDirectory() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            let arobjectFiles = directoryContents.filter{ $0.pathExtension == SavedARScansListViewController.kArObject }
           
            print("arobject urls:",arobjectFiles)
            let fileName = arobjectFiles.map{ $0.deletingPathExtension().lastPathComponent }
            print("object Name list:", fileName)
            for arobject in arobjectFiles {
               
                arrObjectURL.append([SavedARScansListViewController.kArObject:arobject])
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
        if arrObjectURL[indexPath.row].keys.first == SavedARScansListViewController.kArObject {
            vc.objectURL = arrObjectURL[indexPath.row][SavedARScansListViewController.kArObject]
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
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
            filename = "\(self.arrObjectName[indexPath.row]).\(SavedARScansListViewController.kArObject)"
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

