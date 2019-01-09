//
//  PopupViewController.swift
//  geraldph
//
//  Created by Elaine Reyes on 1/31/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import UIKit
import SWRevealViewController

class PopupViewController: SWRevealViewController, SWRevealViewControllerDelegate
{
    // MARK: - IBOutlets
    
    @IBOutlet var coverView: UIView!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    // MARK: - Variables
    
    var urlToLoad = "";
    var isFromLandingPage = false
    
    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.title = self.rightViewController.title;
        
        self.coverView = UIView.init(frame: UIScreen.main.bounds)
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        /* UITapGestureRecognizer */
        
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(sender:)))
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.cancelsTouchesInView = false
        self.rightViewController.view.addGestureRecognizer(tapRecognizer)
        
        /*Title Bar Image*/
        
        let logoImage : UIImage = UIImage(named: "nav_logo")!
        let logoImageView : UIImageView = UIImageView(image: logoImage)
        let navLogoButton = UIButton.init(frame: logoImageView.frame)
        navLogoButton.setImage(logoImage, for: UIControl.State.normal)
        navLogoButton.addTarget(self, action: #selector(logoButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        self.navigationItem.titleView = navLogoButton
        
        /*Add Custom UIView at UINavigationBar*/
        
        self.addCustomNavigationBar()
        
        /* Pass Parameters to DashboardViewController */
        
        if self.rightViewController.isKind(of: UINavigationController.self)
        {
            let navbarVC : UINavigationController = (self.rightViewController as? UINavigationController)!
            let dashboardVC = navbarVC.topViewController as? DashboardViewController
            dashboardVC?.urlToLoad = urlToLoad
            dashboardVC?.isFromLandingPage = isFromLandingPage
        }
    }
    
    func addCustomNavigationBar()
    {
        let defaultBackgroundColor : UIColor = UIColor.init(red: 51/255, green: 132/255, blue: 51/255, alpha: 1.0)
        
        let topNavBarView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.width)!, height: 2))
        topNavBarView.backgroundColor = defaultBackgroundColor
        
        let bottomNavBarView : UIView = UIView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! - 2, width: (self.navigationController?.navigationBar.frame.width)!, height: 2))
        bottomNavBarView.backgroundColor = defaultBackgroundColor
        
        self.navigationController?.navigationBar.addSubview(topNavBarView)
        self.navigationController?.navigationBar.addSubview(bottomNavBarView)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITapGestureRecognizer Delegate Methods
    
    @objc func handleTapGestureRecognizer(sender: UILongPressGestureRecognizer)
    {
        if self.frontViewPosition == FrontViewPosition.leftSide
        {
            self.reveal(self)
        }
    }
    
    // MARK: - UIBarButtonItem Actions
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem)
    {
        let mainController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingPageViewController") as! LandingPageViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = mainController
    }
    
    @IBAction func logoButtonTapped(_ sender: UIBarButtonItem)
    {
        let dashboardVC = (
            storyboard?.instantiateViewController(
                withIdentifier: "PopupViewController")
            ) as? PopupViewController
        dashboardVC?.urlToLoad = landingPageLiveURL
        dashboardVC?.isFromLandingPage = true
        let navigationController = UINavigationController(rootViewController: dashboardVC!)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.currentContext
        navigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func callButtonTapped(_ sender: UIBarButtonItem)
    {
        let phoneNumber = URL(string: "tel://+639175962963")!
        
        if #available(iOS 10.0, *)
        {
            UIApplication.shared.open(phoneNumber)
        }
        else
        {
            UIApplication.shared.openURL(phoneNumber)
        }
    }
    
    @IBAction func reveal(_ sender: Any)
    {
        if self.frontViewPosition == FrontViewPosition.leftSide
        {
            /* Close menu */
            
            self.rightViewRevealWidth = UIScreen.main.bounds.size.width
            self.rightViewRevealOverdraw = 0
            self.setFrontViewPosition(FrontViewPosition.leftSideMost, animated: true)
        }
        else
        {
            /* Open menu */
            
            self.rightViewRevealWidth = 45
            self.rightViewRevealOverdraw = UIScreen.main.bounds.size.width - 45
            
            self.setFrontViewPosition(FrontViewPosition.leftSide, animated: true)
        }
    }
    
    // MARK: - SWRevealControllerDelegate Methods
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition)
    {
        if position == FrontViewPosition.leftSideMost
        {
            self.title = revealController.rightViewController.title
            coverView.removeFromSuperview()
        }
        else
        {
            self.rightViewController.view.addGestureRecognizer(tapRecognizer)
            self.rightViewController.view.addSubview(coverView)
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition)
    {
        
    }
}
