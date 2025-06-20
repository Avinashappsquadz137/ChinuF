//
//  PrivacyPolictVc.swift
//  SanskarEP
//
//  Created by Surya on 21/11/24.
//

import UIKit
import WebKit

class PrivacyPolictVc: UIViewController {

    var url: String?
    
    @IBOutlet weak var webview: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        PrivacyPolicy()
    }

    func setupWebView() {
        let preference = WKWebpagePreferences()
        preference.preferredContentMode = .mobile
        if #available(iOS 14.0, *) {
            webview.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        }
    }

    func PrivacyPolicy() {
        var dict = [String: Any]()
        DispatchQueue.main.async {
            Loader.showLoader()
        }
        APIManager.apiCall(postData: dict as NSDictionary, url: PrivacyPolicyApi) { result, response, error, data in
            DispatchQueue.main.async {
                Loader.hideLoader()
            }
            if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true {
                print(JSON)
                if let data = JSON["data"] as? [String: Any],
                   let privacyPolicyURL = data["Privacy_Policy"] as? String {
                    self.url = privacyPolicyURL
                    print("Privacy Policy URL: \(privacyPolicyURL)")
                    DispatchQueue.main.async {
                        self.loadWebView()
                    }
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func loadWebView() {
        guard let urlString = url, let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webview.load(request)
    }
}
