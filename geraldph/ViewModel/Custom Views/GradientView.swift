//
//  GradientView.swift
//  geraldph
//
//  Created by Elaine Reyes on 2/1/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import UIKit

class GradientView: UIView
{
    // MARK: - View Management
    
    override open class var layerClass: AnyClass
    {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor, UIColor.init(red: 212/255, green: 241/255, blue: 223/255, alpha: 1.0).cgColor]
        
        gradientLayer.locations = [0.53, 0.72]
    }
}
