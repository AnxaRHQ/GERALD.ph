//
//  ViewController.swift
//  geraldph
//
//  Created by Elaine Reyes on 16/08/2017.
//  Copyright © 2017 HAPILABS LIMITED. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, UIWebViewDelegate
{
    // MARK: - IBOutlet
    
    @IBOutlet weak var mainWebview: UIWebView!
    @IBOutlet weak var ai_loader: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - Variables
    
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
                
                self.mainWebview.reload()
                
                if (self.mainWebview.request?.url?.absoluteString.characters.count == 0)
                {
                    self.loadURL()
                }
            }
        }
    }
    
    // MARK: - Load URL
    
    func loadURL()
    {
        let requestURL = NSURL(string:landingPageLiveURL)
        let request : NSMutableURLRequest = NSMutableURLRequest.init(url: requestURL! as URL)
        
        /*Allow Unverified SSL Certificate*/
        
        mainWebview.sessionManager.securityPolicy.allowInvalidCertificates  = true
        
        mainWebview.sessionManager.securityPolicy.validatesDomainName       = false
        
        /*Load URL*/
        
        mainWebview.loadRequest(request as URLRequest, progress: nil, success: { (response, html) in
            
            self.stopAILoader()
            
            return html
            
        }, failure: { (error) in
            
            self.stopAILoader()
            
        })
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
        
        self.updateButtons()
        
        if ((error as NSError).code == NSURLErrorNetworkConnectionLost || (error as NSError).code == NSURLErrorNotConnectedToInternet)
        {
            self.displayAlert(title: "", message: error.localizedDescription)
        }
        else
        {
            print("error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Button Actions
    
    func updateButtons()
    {
        self.backButton.isEnabled       = self.mainWebview.canGoBack
        self.forwardButton.isEnabled    = self.mainWebview.canGoForward
    }
    
    @IBAction func goBackButtonTapped(_ sender: UIBarButtonItem)
    {
        self.mainWebview.goBack()
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIBarButtonItem)
    {
        self.mainWebview.goForward()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem)
    {
        self.mainWebview.reload()
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
}
