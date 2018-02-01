//
//  DashboardViewController.swift
//  geraldph
//
//  Created by Elaine Reyes on 16/08/2017.
//  Copyright © 2017 HAPILABS LIMITED. All rights reserved.
//

import UIKit
import WebKit
import AFNetworking

class DashboardViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate
{
    // MARK: - IBOutlets
    
    @IBOutlet var tempView: UIView!
    @IBOutlet weak var ai_loader: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: - Variables
    
    var mainWebview : WKWebView!
    var urlToLoad = "";
    
    // MARK: - View Management
    
    required init(coder aDecoder: NSCoder)
    {
        mainWebview = WKWebView(frame: .zero)
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /*Add Delegates*/
        
        mainWebview.uiDelegate = self
        mainWebview.navigationDelegate = self
        mainWebview.scrollView.delegate = self
        
        /*Add WKWebView to View*/
        
        self.addWKWebViewToView()
        
        /*Load Activity Indicator*/
        
        self.startAILoader()
        
        /*Load WebView*/
        
        self.loadURL()
        
        /*Customize Navigation Bar Title Attributes*/
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor :  UIColor.init(red: 51/255, green: 132/255, blue: 51/255, alpha: 1.0)]
    }
    
    func addWKWebViewToView()
    {
        tempView.layoutIfNeeded()
        
        var minusiPhoneXHeight : CGFloat = 0.0
        
        if UIScreen.main.nativeBounds.height == 2436
        {
            minusiPhoneXHeight = 25
        }
        
        mainWebview.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: tempView.frame.size.width, height: tempView.frame.size.height - UIApplication.shared.statusBarFrame.size.height - minusiPhoneXHeight)
        
        view.addSubview(mainWebview)
        
        mainWebview.addSubview(ai_loader)
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
    
    @objc func checkInternetConnection()
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
                
                if (self.mainWebview.url?.absoluteString == nil)
                {
                    self.loadURL()
                }
            }
        }
    }
    
    // MARK: - Load URL
    
    func loadURL()
    {
        let requestURL = NSURL(string: urlToLoad)
        let request : NSMutableURLRequest = NSMutableURLRequest.init(url: requestURL! as URL)
        
        mainWebview.allowsBackForwardNavigationGestures = true
        
        var userAgent = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent")
        
        /*set new value for user agent*/
        userAgent = NSString(format: "%@/%@ %@ Mobile %@", "GERALD.ph", Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! NSString, deviceName(), userAgent!) as String
        
        print("userAgent_vc: \(String(describing: userAgent))")
        
        mainWebview.customUserAgent = userAgent
        
        mainWebview.load(request as URLRequest)
    }
    
    // MARK: - ScrollView Delegate Methods
    
    func viewForZooming(in: UIScrollView) -> UIView?
    {
        /*Disable zooming in WKWebView*/
        
        return nil;
    }
    
    // MARK: - WKWebView Delegate Methods
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        self.updateButtons()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        self.stopAILoader()
        
        self.updateButtons()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)
    {
        print("webView-url: \(String(describing: webView.url?.absoluteString))")
        
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
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    {
        print("webView-url: \(String(describing: webView.url?.absoluteString))")
        
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
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        /*Allow Unverified SSL Certificate*/
        
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
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
    
    @IBAction func closeAboutPageButtonTapped(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
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
    
    func deviceName() -> String
    {
        var systemInfo = utsname()
        uname(&systemInfo)
        let model = String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        
        return "Apple/\(model)"
    }
}
