//
//  MainMenuTableViewCell.swift
//  geraldph
//
//  Created by Elaine Reyes on 2/1/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import UIKit

class MainMenuTableViewCell: UITableViewCell
{
    // MARK: - IBOutlet
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var subHeaderLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var collapsibleButton: UIButton!
    @IBOutlet var subCollapsibleButton: UIButton!
    
    // MARK: - View Management
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func removeLabelText()
    {
        subHeaderLabel.text = ""
        subLabel.text = ""
    }
}
