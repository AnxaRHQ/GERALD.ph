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
    @IBOutlet var stepsCounterView: UIView!
    @IBOutlet var noInternetConnectionView: UIView!
    @IBOutlet var stepsValueLabel: UILabel!
    @IBOutlet var activeMinutesLabel: UILabel!
    @IBOutlet var noInternetConnectionLabel: UILabel!
    @IBOutlet weak var ai_loader: UIActivityIndicatorView!
    @IBOutlet var tryAgainButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet var webViewToolbar: UIToolbar!
    
    // MARK: - Variables
    
    var mainWebview : WKWebView!
    var stepCounter = StepCounter()
    var urlToLoad = "";
    var isFromLandingPage = false
    
    // MARK: - View Management
    
    required init(coder aDecoder: NSCoder)
    {
        mainWebview = WKWebView(frame: .zero)
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /* Remove Navigation Bar */
        
        if isFromLandingPage
        {
            /* Remove Navigation Bar */
            
            self.navigationController?.isNavigationBarHidden = true
            
            isFromLandingPage = false
        }
        
        /*Add Delegates*/
        
        mainWebview.uiDelegate = self
        mainWebview.navigationDelegate = self
        mainWebview.scrollView.delegate = self
        
        /*Add WKWebView to View*/
        
        self.addWKWebViewToView()
        
        /*Hide No Internet Connection View*/
        
        self.hideNoInternetConnectionView()
        
        /*Load Activity Indicator*/
        
        self.startAILoader()
        
        /*Load WebView*/
        
        self.loadURL()
        
        /*Customize Try Again Button*/
        
        tryAgainButton.layer.masksToBounds = true
        tryAgainButton.layer.cornerRadius = 8
        
        /*Customize Navigation Bar Title Attributes*/
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor :  UIColor.init(red: 51/255, green: 132/255, blue: 51/255, alpha: 1.0)]
    }
    
    func addWKWebViewToView()
    {
        tempView.layoutIfNeeded()
        
        var minusiPhoneXHeight : CGFloat = 0.0
        var toolbarHeight : CGFloat = 10
        var yValueToAdd : CGFloat = 0
        var statusBarHeight : CGFloat = 0
        
        if UIScreen.main.nativeBounds.height == 2436
        {
            minusiPhoneXHeight = 25
            toolbarHeight   = webViewToolbar.frame.size.height
        }
        
        if (stepsCounterView != nil)
        {
            yValueToAdd     = stepsCounterView.frame.size.height
        }
        else
        {
            statusBarHeight = UIApplication.shared.statusBarFrame.size.height
            toolbarHeight   = webViewToolbar.frame.size.height
        }
        
        mainWebview.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.size.height)! + yValueToAdd, width: tempView.frame.size.width, height: tempView.frame.size.height - minusiPhoneXHeight - statusBarHeight - toolbarHeight - yValueToAdd)
        
        view.addSubview(mainWebview)
        
        mainWebview.addSubview(ai_loader)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        /* AFNetworking */
        
        self.startMonitoring()
        
        /* Step Counter */
        
        if stepsCounterView != nil
        {
            startCurrentDayStepCounter()
        }
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
                    
                    self.hideNoInternetConnectionView()
                    
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
        mainWebview.allowsLinkPreview = true
        
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
        
        webView.evaluateJavaScript("document.body.style.webkitUserSelect='none';document.body.style.webkitTouchCallout='none';", completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)
    {
        print("webView-url: \(String(describing: webView.url?.absoluteString))")
        
        self.stopAILoader()
        
        self.updateButtons()
        
        if ((error as NSError).code == NSURLErrorNetworkConnectionLost || (error as NSError).code == NSURLErrorNotConnectedToInternet)
        {
            noInternetConnectionLabel.text = error.localizedDescription
            self.unhideNoInternetConnectionView()
        }
        else
        {
            self.hideNoInternetConnectionView()
            
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
            noInternetConnectionLabel.text = error.localizedDescription
            self.unhideNoInternetConnectionView()
        }
        else
        {
            self.hideNoInternetConnectionView()
            
            print("error: \(error.localizedDescription)")
        }
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        /*Allow Unverified SSL Certificate*/
        
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
    {
        if let httpResponse = navigationResponse.response as? HTTPURLResponse
        {
            if let headers = httpResponse.allHeaderFields as? [String: String], let url = httpResponse.url
            {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
                
                for cookie in cookies
                {
                    if cookie.name == "Nop.customer"
                    {
                        let regID : String = cookie.value
                        
                        UserDefaults.standard.set(regID, forKey: "regID")
                        
                        print("regID: \(regID)")
                    }
                    
                    print("Cookie: ",cookie.description)
                    
                    //print("Cookie.Name: " + cookie.name + " \nCookie.Value: " + cookie.value)
                }
                
                HTTPCookieStorage.shared.setCookies(cookies , for: httpResponse.url!, mainDocumentURL: nil)
            }
        }
        
        decisionHandler(.allow)
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
    
    @IBAction func closeButtonTapped(_ sender: UIButton)
    {
        self.mainWebview.reload()
        
        if (self.mainWebview.url?.absoluteString == nil)
        {
            self.loadURL()
        }
        
        startAILoader()
    }
    
    @IBAction func closeAboutPageButtonTapped(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Hide / Unhide No Internet Connection View
    
    func hideNoInternetConnectionView()
    {
        noInternetConnectionView.isHidden = true
        
        view.sendSubview(toBack: noInternetConnectionView)
        view.bringSubview(toFront: mainWebview)
        view.bringSubview(toFront: ai_loader)
    }
    
    func unhideNoInternetConnectionView()
    {
        noInternetConnectionView.isHidden = false
        
        view.sendSubview(toBack: mainWebview)
        view.bringSubview(toFront: noInternetConnectionView)
        view.bringSubview(toFront: ai_loader)
        
        stopAILoader()
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
    
    // MARK: - Get Device Name
    
    func deviceName() -> String
    {
        var systemInfo = utsname()
        uname(&systemInfo)
        let model = String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        
        return "Apple/\(model)"
    }
    
    // MARK: - Core Motion Delegate Methods
    
    func startCurrentDayStepCounter()
    {
        stepCounter = StepCounter.shared
        
        if StepCounter.isStepCountingAvailable()
        {
            stepCounter.addObserver(self, forKeyPath: "stepsToday", options: NSKeyValueObservingOptions.new, context: nil)
            
            self.updateSteps(stepsToday: stepCounter.stepsToday)
        }
    }
    
    func updateSteps(stepsToday : NSInteger)
    {
        DispatchQueue.main.async
            {
                if stepsToday > 0
                {
                    self.stepsValueLabel.text    = "\(Int(stepsToday))"
                    
                    let timeMoving              = self.stepCounter.timeMoving
                    
                    self.activeMinutesLabel.text = "\(CalendarUtil.sharedInstance.secondsToHoursMinutesSeconds(seconds: Int(timeMoving)))"
                }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        self.updateSteps(stepsToday: stepCounter.stepsToday)
    }
    
    func stopStepCounter()
    {
        if stepCounter.isCounting
        {
            if StepCounter.isStepCountingAvailable()
            {
                stepCounter.addObserver(self, forKeyPath: "stepsToday", options: NSKeyValueObservingOptions.new, context: nil)
                
                stepCounter.removeObserver(self, forKeyPath: "stepsToday")
            }
        }
    }
    
    func dealloc()
    {
        self.stopStepCounter()
    }
}
