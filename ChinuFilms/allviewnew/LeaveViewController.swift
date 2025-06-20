//
//  LeaveViewController.swift
//  SanskarEP
//
//  Created by Surya on 21/08/24.
//

import UIKit

class LeaveViewController: UIViewController {
    
    
    
    @IBOutlet weak var policyno: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Policyamnt: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        policyno.text = currentUser.PolicyNumber
        Policyamnt.text = currentUser.PolicyAmount
        Date.text = currentUser.PolicyValidity
    }
    
    
    @IBAction func Downloadbtn(_ sender: UIButton) {
   //     downloadAndSavePDF(from: url)
    }
    
//    private func downloadAndSavePDF(from url: URL) {
//        let session = URLSession.shared
//        let downloadTask = session.downloadTask(with: url) { (tempLocalUrl, response, error) in
//            if let tempLocalUrl = tempLocalUrl, error == nil {
//                do {
//                    // Move the file to the Documents directory
//                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                    let savedURL = documentsURL.appendingPathComponent(url.lastPathComponent)
//                    
//                    // Remove the file if it already exists
//                    if FileManager.default.fileExists(atPath: savedURL.path) {
//                        try FileManager.default.removeItem(at: savedURL)
//                    }
//                    
//                    try FileManager.default.moveItem(at: tempLocalUrl, to: savedURL)
//                    
//                    // Present the option to save or share the file
//                    DispatchQueue.main.async {
//                        self.presentSaveToFilesOption(fileUrl: savedURL)
//                    }
//                } catch {
//                    // Handle error
//                    print("Error saving the PDF: \(error.localizedDescription)")
//                }
//            } else {
//                // Handle error
//                print("Error downloading the PDF: \(error?.localizedDescription ?? "Unknown error")")
//            }
//        }
//        downloadTask.resume()
//    }
//    
//    private func presentSaveToFilesOption(fileUrl: URL) {
//        let activityViewController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
//        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact]
//        present(activityViewController, animated: true, completion: nil)
//    }
//
}
