//
//  StoriesCell.swift
//  EngineerintAITask
//
//  Created by OJAS on 12/24/19.
//  Copyright © 2019 OJAS. All rights reserved.
//

import UIKit

class StoriesCell: UITableViewCell {

    @IBOutlet weak var lbl_title : UILabel!
    @IBOutlet weak var lbl_createdDate : UILabel!
    @IBOutlet weak var switch_toggle : UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbl_title.text = ""
        lbl_title.textColor = BLACK_COLOR
        lbl_title.numberOfLines = 0
        lbl_createdDate.lineBreakMode = .byWordWrapping
        
        lbl_createdDate.text = ""
        lbl_createdDate.textColor = GRAY_COLOR
        lbl_createdDate.numberOfLines = 1
        
        switch_toggle.isOn = false
        switch_toggle.isUserInteractionEnabled = false
    }
    
    func setStoriesData(data : NSDictionary , indexpath : IndexPath , delegate : Any) {
        
        if let title = ENG_NULL_EMPTY(data.object(forKey: "title") as AnyObject) as? String , !title.isEmpty {
            lbl_title.text = title
        }
        
        if let createdDate = ENG_NULL_EMPTY(data.object(forKey: "created_at") as AnyObject) as? String , !createdDate.isEmpty {
            lbl_createdDate.text = Date().getFormatedDate(dateString: createdDate)
        }
    }
}
