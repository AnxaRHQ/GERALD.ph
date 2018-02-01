//
//  MenuViewController.swift
//  geraldph
//
//  Created by Elaine Reyes on 1/31/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import UIKit
import SWRevealViewController

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - IBOutlet
    
    @IBOutlet var menuTableView: UITableView!
    @IBOutlet var bottomTableViewConstant: NSLayoutConstraint!
    
    // MARK: - Variables
    
    enum TableSection: Int
    {
        case home = 0, bakery, meat, deli, seafood, fruitAndVeg, pasta, wine, cheese, iceCream, asian, healthyLiving, glutenFree
    }
    
    var mainMenuArray               = [String]()
    var bakeryContentsArray         = [String]()
    var meatContentsArray           = [String]()
    var beefContentsArray           = [String]()
    var deliContentsArray           = [String]()
    var fruitsAndVegContentsArray   = [String]()
    var pastaContentsArray          = [String]()
    var wineContentsArray           = [String]()
    var redWineContentsArray        = [String]()
    var whiteWineContentsArray      = [String]()
    var roseWineContentsArray       = [String]()
    var sparklingWineContentsArray  = [String]()
    var cheeseContentsArray         = [String]()
    var iceCreamContentsArray       = [String]()
    var healthyEatingContentsArray  = [String]()
    var glutenFreeContentsArray     = [String]()
    
    var mainMenuLinksArray          = [String]()
    var bakeryLinksArray            = [String]()
    var meatLinksArray              = [String]()
    var beefLinksArray              = [String]()
    var deliLinksArray              = [String]()
    var fruitsAndVegLinksArray      = [String]()
    var pastaLinksArray             = [String]()
    var wineLinksArray              = [String]()
    var redWineLinksArray           = [String]()
    var whiteWineLinksArray         = [String]()
    var roseWineLinksArray          = [String]()
    var sparklingWineLinksArray     = [String]()
    var cheeseLinksArray            = [String]()
    var iceCreamLinksArray          = [String]()
    var healthyEatingLinksArray     = [String]()
    var glutenFreeLinksArray        = [String]()
    
    var isBakeryContentsHide        = true
    var isMeatContentsHide          = true
    var isBeefContentsHide          = true
    var isDeliContentsHide          = true
    var isFruitsAndVegContentsHide  = true
    var isPastaContentsHide         = true
    var isWineContentsHide          = true
    var isRedWineContentsHide       = true
    var isWhiteWineContentsHide     = true
    var isRoseWineContentsHide      = true
    var isSparklingContentsHide     = true
    var isCheeseContentsHide        = true
    var isIceCreamContentsHide      = true
    var isHealthyLivingContentsHide = true
    var isGlutenFreeContentsHide    = true
    
    // MARK: - View Management
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /* Strings */
        
        contentStrings()
        
        /* Links */
        
        contentLinks()
        
        /* Remove Footer View Lines */
        
        menuTableView.tableFooterView = UIView(frame: .zero)
        
        /* Left Side Menu */
        
        leftSideMenu()
    }
    
    func contentStrings()
    {
        mainMenuArray               = ContentUtil.sharedInstance.mainMenuContentsArray()
        bakeryContentsArray         = ContentUtil.sharedInstance.bakeryContentsArray()
        meatContentsArray           = ContentUtil.sharedInstance.meatContentsArray()
        beefContentsArray           = ContentUtil.sharedInstance.beefContentsArray()
        deliContentsArray           = ContentUtil.sharedInstance.deliContentsArray()
        fruitsAndVegContentsArray   = ContentUtil.sharedInstance.fruitsAndVegContentsArray()
        pastaContentsArray          = ContentUtil.sharedInstance.pastaContentsArray()
        wineContentsArray           = ContentUtil.sharedInstance.wineContentsArray()
        redWineContentsArray        = ContentUtil.sharedInstance.redWineContentsArray()
        whiteWineContentsArray      = ContentUtil.sharedInstance.whiteWineContentsArray()
        roseWineContentsArray       = ContentUtil.sharedInstance.roseWineContentsArray()
        sparklingWineContentsArray  = ContentUtil.sharedInstance.sparklingWineContentsArray()
        cheeseContentsArray         = ContentUtil.sharedInstance.cheeseContentsArray()
        iceCreamContentsArray       = ContentUtil.sharedInstance.iceCreamContentsArray()
        healthyEatingContentsArray  = ContentUtil.sharedInstance.healthyEatingContentsArray()
        glutenFreeContentsArray     = ContentUtil.sharedInstance.glutenFreeContentsArray()
    }
    
    func contentLinks()
    {
        mainMenuLinksArray          = ContentUtil.sharedInstance.mainMenuLinksArray()
        bakeryLinksArray            = ContentUtil.sharedInstance.bakeryLinksArray()
        meatLinksArray              = ContentUtil.sharedInstance.meatLinksArray()
        beefLinksArray              = ContentUtil.sharedInstance.beefLinksArray()
        deliLinksArray              = ContentUtil.sharedInstance.deliLinksArray()
        fruitsAndVegLinksArray      = ContentUtil.sharedInstance.fruitsAndVegLinksArray()
        pastaLinksArray             = ContentUtil.sharedInstance.pastaLinksArray()
        wineLinksArray              = ContentUtil.sharedInstance.wineLinksArray()
        redWineLinksArray           = ContentUtil.sharedInstance.redWineLinksArray()
        whiteWineLinksArray         = ContentUtil.sharedInstance.whiteWineLinksArray()
        roseWineLinksArray          = ContentUtil.sharedInstance.roseWineLinksArray()
        sparklingWineLinksArray     = ContentUtil.sharedInstance.sparklingWineLinksArray()
        cheeseLinksArray            = ContentUtil.sharedInstance.cheeseLinksArray()
        iceCreamLinksArray          = ContentUtil.sharedInstance.iceCreamLinksArray()
        healthyEatingLinksArray     = ContentUtil.sharedInstance.healthyEatingLinksArray()
        glutenFreeLinksArray        = ContentUtil.sharedInstance.glutenFreeLinksArray()
    }
    
    func leftSideMenu()
    {
        let revealViewController : SWRevealViewController = self.revealViewController()
        
        if (self.revealViewController() != nil)
        {
            revealViewController.presentFrontViewHierarchically = true
            revealViewController.rightViewRevealOverdraw = 0
            revealViewController.rightViewRevealWidth = UIScreen.main.bounds.size.width
            revealViewController.frontViewPosition = FrontViewPosition.leftSideMost
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if UIScreen.main.nativeBounds.height == 2436
        {
            bottomTableViewConstant.constant = UIApplication.shared.statusBarFrame.size.height + ((self.navigationController?.navigationBar.frame.size.height)! * 2)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return mainMenuArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let tableSection = TableSection(rawValue: section)
        {
            switch tableSection
            {
                
            case .bakery:
                return bakeryContentsArray.count + 1
                
            case .meat:
                return meatContentsArray.count + beefContentsArray.count + 1
                
            case .deli:
                return deliContentsArray.count + 1
                
            case .fruitAndVeg:
                return fruitsAndVegContentsArray.count + 1
                
            case .pasta:
                return pastaContentsArray.count + 1
                
            case .wine:
                return wineContentsArray.count + redWineContentsArray.count + whiteWineContentsArray.count + roseWineContentsArray.count + sparklingWineContentsArray.count + 1
                
            case .cheese:
                return cheeseContentsArray.count + 1
            
            case .iceCream:
                return iceCreamContentsArray.count + 1
                
            case .healthyLiving:
                return healthyEatingContentsArray.count + 1
                
            case .glutenFree:
                return glutenFreeContentsArray.count + 1
                
            default:
                return 1
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cellIdentifier : String = "subMenuCell"
        
        if indexPath.row == 0
        {
            /* Default for Main Menu */
            
            cellIdentifier = "mainMenuCell"
        }
        
        let menuCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MainMenuTableViewCell
        
        /* Header */
        
        if indexPath.row == 0
        {
            menuCell?.headerLabel.text = mainMenuArray[indexPath.section]
            
            menuCell?.collapsibleButton.tag = indexPath.section
            
            /* Hide Collapsible Button */
            
            if indexPath.section == 0 || indexPath.section == 4 || indexPath.section == 10
            {
                menuCell?.collapsibleButton.isHidden = true
            }
            else
            {
                menuCell?.collapsibleButton.isHidden = false
            }
        }
        
        /* Sections */
        
        if let tableSection = TableSection(rawValue: indexPath.section)
        {
            switch tableSection
            {
                
            case .home: break
            
            case .bakery:
                
                if indexPath.row >= 1
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = bakeryContentsArray[indexPath.row - 1]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                
            case .meat:
                
                if indexPath.row == 0
                {
                    menuCell?.collapsibleButton.isHidden = false
                }
                else if indexPath.row == 1
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = meatContentsArray[0]
                    
                    menuCell?.subCollapsibleButton.isHidden = false
                    
                    /* Beef */
                    
                    menuCell?.subCollapsibleButton.tag = 1
                }
                else if indexPath.row >= 2 && indexPath.row < (beefContentsArray.count+2)
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subLabel.text = beefContentsArray[indexPath.row - 2]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                else
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = meatContentsArray[indexPath.row - (beefContentsArray.count + 1)]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                
            case .deli:
                
                if indexPath.row >= 1
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = deliContentsArray[indexPath.row - 1]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                
            case .seafood: break
                
            case .fruitAndVeg:
                
                if indexPath.row >= 1
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = fruitsAndVegContentsArray[indexPath.row - 1]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                
            case .pasta:
                
                if indexPath.row >= 1
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = pastaContentsArray[indexPath.row - 1]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                
            case .wine:
                
                if indexPath.row == 0
                {
                    menuCell?.collapsibleButton.isHidden = false
                }
                else if indexPath.row == 1
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = wineContentsArray[0]
                    
                    menuCell?.subCollapsibleButton.isHidden = false
                    
                    /* Red Wine */
                    
                    menuCell?.subCollapsibleButton.tag = 2
                }
                else if indexPath.row >= 2 && indexPath.row < 8
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subLabel.text = redWineContentsArray[indexPath.row - 2]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                else if indexPath.row == 8
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = wineContentsArray[1]
                    
                    menuCell?.subCollapsibleButton.isHidden = false
                    
                    /* White Wine */
                    
                    menuCell?.subCollapsibleButton.tag = 3
                }
                else if indexPath.row > 8 && indexPath.row <= 14
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subLabel.text = whiteWineContentsArray[indexPath.row - 9]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                else if indexPath.row == 15
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = wineContentsArray[2]
                    
                    menuCell?.subCollapsibleButton.isHidden = false
                    
                    /* Rose Wine */
                    
                    menuCell?.subCollapsibleButton.tag = 4
                }
                else if indexPath.row > 15 && indexPath.row <= 18
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subLabel.text = roseWineContentsArray[indexPath.row - 16]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                else if indexPath.row == 19
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = wineContentsArray[3]
                    
                    menuCell?.subCollapsibleButton.isHidden = false
                    
                    /* Sparkling Wine */
                    
                    menuCell?.subCollapsibleButton.tag = 5
                }
                else if indexPath.row > 19 && indexPath.row <= 21
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subLabel.text = sparklingWineContentsArray[indexPath.row - 20]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                else if indexPath.row == 22
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = wineContentsArray[4]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                else if indexPath.row == 23
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = wineContentsArray[5]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                
            case .cheese:
                
                if indexPath.row >= 1
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = cheeseContentsArray[indexPath.row - 1]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                
            case .iceCream:
                
                if indexPath.row >= 1
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = iceCreamContentsArray[indexPath.row - 1]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                
            case .asian: break
                
            case .healthyLiving:
                
                if indexPath.row >= 1
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = healthyEatingContentsArray[indexPath.row - 1]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                
            case .glutenFree:
                
                if indexPath.row >= 1
                {
                    menuCell?.removeLabelText()
                    
                    menuCell?.subHeaderLabel.text = glutenFreeContentsArray[indexPath.row - 1]
                    
                    menuCell?.subCollapsibleButton.isHidden = true
                }
                
            }
        }
        
        return menuCell!
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if let tableSection = TableSection(rawValue: indexPath.section)
        {
            switch tableSection
            {
                
            case .bakery:
                
                if indexPath.row >= 1
                {
                    if isBakeryContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                
            case .meat:
                
                if indexPath.row == 0
                {
                    return 44
                }
                else if indexPath.row >= 2 && indexPath.row < (beefContentsArray.count+2)
                {
                    if isBeefContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                else
                {
                    if isMeatContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                
            case .deli:
                
                if indexPath.row >= 1
                {
                    if isDeliContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                
            case .fruitAndVeg:
                
                if indexPath.row >= 1
                {
                    if isFruitsAndVegContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                
            case .pasta:
                
                if indexPath.row >= 1
                {
                    if isPastaContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                
            case .wine:
                
                if indexPath.row == 0
                {
                    return 44
                }
                else if indexPath.row >= 2 && indexPath.row < 8
                {
                    if isRedWineContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                else if indexPath.row > 8 && indexPath.row <= 14
                {
                    if isWhiteWineContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                else if indexPath.row > 15 && indexPath.row <= 18
                {
                    if isRoseWineContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                else if indexPath.row > 19 && indexPath.row <= 21
                {
                    if isSparklingContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                else
                {
                    if isWineContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                
            case .cheese:
                
                if indexPath.row >= 1
                {
                    if isCheeseContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                
            case .iceCream:
                
                if indexPath.row >= 1
                {
                    if isIceCreamContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                
            case .asian: break
                
            case .healthyLiving:
                
                if indexPath.row >= 1
                {
                    if isHealthyLivingContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                
            case .glutenFree:
                
                if indexPath.row >= 1
                {
                    if isGlutenFreeContentsHide
                    {
                        return 0
                    }
                    
                    return 31
                }
                
            default:
                
                return 44
            }
        }
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dashboardVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        
        var urlToLoad : String = ""
        
        /* Sections */
        
        if let tableSection = TableSection(rawValue: indexPath.section)
        {
            switch tableSection
            {
                
            case .home:
                
                if indexPath.row == 0
                {
                    urlToLoad = mainMenuLinksArray[0]
                }
            
            case .bakery:
                
                if indexPath.row == 0
                {
                    urlToLoad = mainMenuLinksArray[1]
                }
                else
                {
                    urlToLoad = bakeryLinksArray[indexPath.row - 1]
                }
                
            case .meat:
                
                if indexPath.row == 0
                {
                    urlToLoad = mainMenuLinksArray[2]
                }
                else if indexPath.row == 1
                {
                    /* Beef */
                    
                    urlToLoad = meatLinksArray[0]
                }
                else if indexPath.row >= 2 && indexPath.row <= 5
                {
                    urlToLoad = beefLinksArray[indexPath.row - 2]
                }
                else if indexPath.row == 6
                {
                    urlToLoad = meatLinksArray[1]
                }
                else if indexPath.row == 7
                {
                    urlToLoad = meatLinksArray[2]
                }
                else if indexPath.row == 8
                {
                    urlToLoad = meatLinksArray[3]
                }
                else if indexPath.row == 9
                {
                    urlToLoad = meatLinksArray[4]
                }
                else if indexPath.row == 10
                {
                    urlToLoad = meatLinksArray[5]
                }
                else if indexPath.row == 11
                {
                    urlToLoad = meatLinksArray[6]
                }
                else if indexPath.row == 12
                {
                    urlToLoad = meatLinksArray[7]
                }
                else if indexPath.row == 13
                {
                    urlToLoad = meatLinksArray[8]
                }
                
            case .deli:
                
                if indexPath.row == 0
                {
                    urlToLoad = mainMenuLinksArray[3]
                }
                else
                {
                    urlToLoad = deliLinksArray[indexPath.row - 1]
                }
                
            case .seafood:
                
                if indexPath.row == 0
                {
                    urlToLoad = mainMenuLinksArray[4]
                }
                
            case .fruitAndVeg:
                
                if indexPath.row == 0
                {
                    urlToLoad = mainMenuLinksArray[5]
                }
                else
                {
                    urlToLoad = fruitsAndVegLinksArray[indexPath.row - 1]
                }
                
            case .pasta:
                
                if indexPath.row == 0
                {
                    urlToLoad = mainMenuLinksArray[6]
                }
                else
                {
                    urlToLoad = pastaLinksArray[indexPath.row - 1]
                }
                
            case .wine:
                
                if indexPath.row == 0
                {
                    urlToLoad = mainMenuLinksArray[7]
                }
                else if indexPath.row == 1
                {
                    /* Red Wine */
                    
                    urlToLoad = wineLinksArray[0]
                }
                else if indexPath.row >= 2 && indexPath.row < 8
                {
                    urlToLoad = redWineLinksArray[indexPath.row - 2]
                }
                else if indexPath.row == 8
                {
                    /* White Wine */
                    
                    urlToLoad = wineLinksArray[1]
                }
                else if indexPath.row > 8 && indexPath.row <= 14
                {
                    urlToLoad = whiteWineLinksArray[indexPath.row - 9]
                }
                else if indexPath.row == 15
                {
                    /* Rose Wine */
                    
                    urlToLoad = wineLinksArray[2]
                }
                else if indexPath.row > 15 && indexPath.row <= 18
                {
                    urlToLoad = roseWineLinksArray[indexPath.row - 16]
                }
                else if indexPath.row == 19
                {
                    /* Sparkling Wine */
                    
                    urlToLoad = wineLinksArray[3]
                }
                else if indexPath.row > 19 && indexPath.row <= 21
                {
                    urlToLoad = sparklingWineLinksArray[indexPath.row - 20]
                }
                else if indexPath.row == 22
                {
                    /* Sweet Wine */
                    
                    urlToLoad = wineLinksArray[4]
                }
                else if indexPath.row == 23
                {
                    /* Liquor Wine */
                    
                    urlToLoad = wineLinksArray[5]
                }
                
            case .cheese:
                
                if indexPath.row == 0
                {
                    urlToLoad = mainMenuLinksArray[8]
                }
                else
                {
                    urlToLoad = cheeseLinksArray[indexPath.row - 1]
                }
                
            case .iceCream:
                
                if indexPath.row == 0
                {
                    urlToLoad = mainMenuLinksArray[9]
                }
                else
                {
                    urlToLoad = iceCreamLinksArray[indexPath.row - 1]
                }
                
            case .asian:
                
                if indexPath.row == 0
                {
                    urlToLoad = mainMenuLinksArray[10]
                }
                
            case .healthyLiving:
                
                if indexPath.row == 0
                {
                    urlToLoad = mainMenuLinksArray[11]
                }
                else
                {
                    urlToLoad = healthyEatingLinksArray[indexPath.row - 1]
                }
                
            case .glutenFree:
                
                if indexPath.row == 0
                {
                    urlToLoad = mainMenuLinksArray[12]
                }
                else
                {
                    urlToLoad = glutenFreeLinksArray[indexPath.row - 1]
                }
            }
        }
        
        dashboardVC.urlToLoad = urlToLoad
        
        self.revealViewController().rightViewController     = dashboardVC
        self.revealViewController().rightViewRevealOverdraw = 0
        self.revealViewController().rightViewRevealWidth    = UIScreen.main.bounds.size.width
        self.revealViewController().frontViewPosition       = FrontViewPosition.leftSideMost
    }
    
    // MARK: - Button Actions
    
    @IBAction func collapsibleButtonTapped(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            isBakeryContentsHide        = !isBakeryContentsHide
        }
        else if sender.tag == 2
        {
            isMeatContentsHide          = !isMeatContentsHide
        }
        else if sender.tag == 3
        {
            isDeliContentsHide          = !isDeliContentsHide
        }
        else if sender.tag == 5
        {
            isFruitsAndVegContentsHide  = !isFruitsAndVegContentsHide
        }
        else if sender.tag == 6
        {
            isPastaContentsHide         = !isPastaContentsHide
        }
        else if sender.tag == 7
        {
            isWineContentsHide          = !isWineContentsHide
        }
        else if sender.tag == 8
        {
            isCheeseContentsHide        = !isCheeseContentsHide
        }
        else if sender.tag == 9
        {
            isIceCreamContentsHide      = !isIceCreamContentsHide
        }
        else if sender.tag == 11
        {
            isHealthyLivingContentsHide = !isHealthyLivingContentsHide
        }
        else if sender.tag == 12
        {
            isGlutenFreeContentsHide    = !isGlutenFreeContentsHide
        }
        
        menuTableView.reloadData()
    }
    
    @IBAction func subCollapsibleButtonTapped(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            isBeefContentsHide          = !isBeefContentsHide
        }
        else if sender.tag == 2
        {
            isRedWineContentsHide       = !isRedWineContentsHide
        }
        else if sender.tag == 3
        {
            isWhiteWineContentsHide     = !isWhiteWineContentsHide
        }
        else if sender.tag == 4
        {
            isRoseWineContentsHide      = !isRoseWineContentsHide
        }
        else if sender.tag == 5
        {
            isSparklingContentsHide     = !isSparklingContentsHide
        }
        
        menuTableView.reloadData()
    }
}
