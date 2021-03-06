//
//  LandingPageViewController.swift
//  geraldph
//
//  Created by Elaine Reyes on 2/1/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController
{
    // MARK: - IBOutlet
    
    @IBOutlet var discoverButton: UIButton!
    @IBOutlet var registrationButton: UIButton!
    @IBOutlet var logoWidth: NSLayoutConstraint!
    @IBOutlet var bottomGradientConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /*Customize Buttons*/
        
        discoverButton.layer.masksToBounds = true
        discoverButton.layer.cornerRadius = 9
        
        registrationButton.layer.masksToBounds = true
        registrationButton.layer.cornerRadius = 9
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.layoutIfNeeded()
        
        if UIScreen.main.bounds.size.height == 480
        {
            logoWidth.constant = 275
        }
        else if UIScreen.main.bounds.size.height == 736
        {
             logoWidth.constant = 410
        }
        else if UIScreen.main.bounds.size.height == 2436
        {
            bottomGradientConstraint.constant = -30
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segue
    
    func dashboardViewController(urlToLoad : String, isModal : Bool)
    {
        if isModal
        {
            let dashboardVC = (
                storyboard?.instantiateViewController(
                    withIdentifier: "InfoViewController")
                ) as? DashboardViewController
            dashboardVC?.urlToLoad = aboutPageURL
            dashboardVC?.isFromLandingPage = false
            dashboardVC?.title = "About Us"
            let navigationController = UINavigationController(rootViewController: dashboardVC!)
            present(navigationController, animated: true, completion: nil)
        }
        else
        {
            let dashboardVC = (
                storyboard?.instantiateViewController(
                    withIdentifier: "PopupViewController")
                ) as? PopupViewController
            dashboardVC?.urlToLoad = urlToLoad
            dashboardVC?.isFromLandingPage = true
            let navigationController = UINavigationController(rootViewController: dashboardVC!)
            navigationController.modalPresentationStyle = UIModalPresentationStyle.currentContext
            navigationController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func discoverButtonTapped(_ sender: UIButton)
    {
        dashboardViewController(urlToLoad: landingPageLiveURL, isModal: false)
    }
    
    @IBAction func connectButtonTapped(_ sender: UIButton)
    {
        dashboardViewController(urlToLoad: loginPageURL, isModal: false)
    }
    
    @IBAction func registrationButtonTapped(_ sender: UIButton)
    {
        dashboardViewController(urlToLoad: registrationPageURL, isModal: false)
    }
    
    @IBAction func aboutButtonTapped(_ sender: UIButton)
    {
        dashboardViewController(urlToLoad: aboutPageURL, isModal: true)
    }
}
