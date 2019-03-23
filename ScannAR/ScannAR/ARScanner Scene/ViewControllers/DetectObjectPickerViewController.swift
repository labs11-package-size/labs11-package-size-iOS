//
//  DetectObjectPickerViewController.swift
//  ScannAR
//
//  Created by Joshua Kaunert on 3/22/19.
//  Copyright © 2019 ScannAR Team. All rights reserved.
//

import Foundation
import UIKit

extension DetectObjectPickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arObjectName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "arobjectListCell")
        let label = cell?.viewWithTag(42) as? UILabel
        label?.text = arObjectName[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetectARObjectVC") as! ARDetectViewController
        vc.objectURL = arObjectURL[indexPath.row][DetectObjectPickerViewController.arObject]
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let fileManager = FileManager.default
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            guard let directoryPath = paths.first else { return }
            
            var filename = "\(self.arObjectName[indexPath.row]).\(DetectObjectPickerViewController.arObject)"
            let filePath = "\(directoryPath)/\(filename)"
            do {
                try fileManager.removeItem(atPath: filePath)
                DispatchQueue.main.async {
                    self.arObjectName.remove(at: indexPath.row)
                    self.arObjectURL.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }catch let error as NSError {
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
    
    func setBackgroundText(with message: String) {
        
        let backgroundLabel = UILabel()
        backgroundLabel.font = UIFont.systemFont(ofSize: 21)
        backgroundLabel.textColor = .black
        backgroundLabel.numberOfLines = 0
        
        backgroundLabel.textAlignment = .center
        backgroundLabel.text = message
        backgroundLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundLabel.translatesAutoresizingMaskIntoConstraints = true
        
        self.backgroundView = backgroundLabel
        
    }
    
    func removeBackgroundText() {
        self.backgroundView = nil
    }
}


class DetectObjectPickerViewController: UIViewController {
    
    @IBOutlet weak var cancelObjectPickerButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    static let arObject = "arobject"
    var arObjectName: [String] = []
    var arObjectURL: [[String : URL]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllSavedARObjectsFromFileManager()
    }
    
    func fetchAllSavedARObjectsFromFileManager() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            let arobjectFiles = directoryContents.filter{ $0.pathExtension == DetectObjectPickerViewController.arObject }
            print("arobject urls:",arobjectFiles)
            let fileName = arobjectFiles.map { $0.deletingPathExtension().lastPathComponent }
            print("object Name list:", fileName)
            for arobject in arobjectFiles {
                arObjectURL.append([DetectObjectPickerViewController.arObject:arobject])
            }
            arObjectName = fileName
            if arObjectName.count == 0 {
                // FIXME: -  to an alertcontroller LAZY!
                DispatchQueue.main.async {
                    self.tableView.setBackgroundText(with: "There currently no saved objects on your device. \n Please scan and save an arobject with the object scanning utility before attempting object detection.")
                    self.tableView.reloadData()
                }
            } else {
                self.tableView.delegate = self
                self.tableView.dataSource = self
                DispatchQueue.main.async {
                    self.tableView.removeBackgroundText()
                    self.tableView.reloadData()
                }
                
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

