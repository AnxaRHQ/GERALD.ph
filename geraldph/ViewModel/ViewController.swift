//
//  ViewController.swift
//  geraldph
//
//  Created by Elaine Reyes on 16/08/2017.
//  Copyright © 2017 HAPILABS LIMITED. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate
{
    // MARK: - IBOutlet
    
    // MARK: - Variables
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var ai_loader: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /*Load Activity Indicator*/
        
        self.startAILoader()
        
        /*Load WebView*/
        
        self.loadURL()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        /*AFNetworking*/
        
        self.startMonitoring()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.stopAILoader()
        
        /*AFNetworking*/
        
        self.stopMonitoring()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - AFNetworking Delegate Methods
    
    func startMonitoring()
    {
        AFNetworkReachabilityManager.shared().startMonitoring()
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkInternetConnection), name: NSNotification.Name.AFNetworkingReachabilityDidChange, object: nil)
    }
    
    func stopMonitoring()
    {
        AFNetworkReachabilityManager.shared().stopMonitoring()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AFNetworkingReachabilityDidChange, object: nil)
    }
    
    func checkInternetConnection()
    {
        DispatchQueue.main.async
        {
            AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status: AFNetworkReachabilityStatus) -> Void in
                switch status
                {
                case .notReachable:
                    print("Not reachable")
                    
                    /*Stop Activity Indicator*/
                    
                    self.stopAILoader()
                    
                case .reachableViaWiFi, .reachableViaWWAN:
                    print("Reachable")
                    
                    /*Load Activity Indicator*/
                    
                    self.startAILoader()
                    
                case .unknown:
                    
                    print("Unknown")
                    
                    /*Stop Activity Indicator*/
                    
                    self.stopAILoader()
                }
                
                /*Reload WebView*/
                
                self.webView.reload()
                
                if (self.webView.request?.url?.absoluteString.characters.count == 0)
                {
                    self.loadURL()
                }
            }
        }
    }
    
    // MARK: - Load URL
    
    func loadURL()
    {
        let requestURL = NSURL(string:landingPageQCURL)
        let request : NSMutableURLRequest = NSMutableURLRequest.init(url: requestURL! as URL)
        
        /*Add User-agent*/
        
        var userAgent = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent")
        userAgent = NSString(format: "%@/%@ Apple/%@ Mobile %@", appName, Bundle.main.infoDictionary?["CFBundleVersion"] as! CVarArg, self.platform(), userAgent!) as String
        
        print("userAgent: \(String(describing: userAgent))")
        
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        /*Load URL*/
        
        webView.loadRequest(request as URLRequest)
    }
    
    // MARK: - UIWebView Delegate Methods
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        self.updateButtons()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.stopAILoader()
        
        self.updateButtons()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        print("webView-url: \(String(describing: webView.request?.url?.absoluteString))")
        
        self.stopAILoader()
        
        self.displayAlert(title: "", message: error.localizedDescription)
        
        self.updateButtons()
    }
    
    // MARK: - Button Actions
    
    func updateButtons()
    {
        self.backButton.isEnabled       = self.webView.canGoBack
        self.forwardButton.isEnabled    = self.webView.canGoForward
    }
    
    @IBAction func goBackButtonTapped(_ sender: UIBarButtonItem)
    {
        self.webView.goBack()
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIBarButtonItem)
    {
        self.webView.goForward()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem)
    {
        self.webView.reload()
    }
    
    // MARK: - Activity Indicator Methods
    
    func startAILoader()
    {
        ai_loader.startAnimating()
        ai_loader.isHidden = false
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func stopAILoader()
    {
        ai_loader.stopAnimating()
        ai_loader.isHidden = true
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: - UIAlertAction
    
    func displayAlert(title: String, message: String)
    {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Get Device Name
    
    func platform() -> String
    {
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
