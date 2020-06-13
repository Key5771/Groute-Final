//
//  SecondTabTableViewCell.swift
//  Groute
//
//  Created by 이민재 on 17/05/2020.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit

class SecondTabTableViewCell: UITableViewCell {

    @IBOutlet weak var routeImage: UIImageView!
    @IBOutlet weak var addressName: UILabel!
    @IBOutlet weak var Time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        routeImage.layer.cornerRadius = routeImage.frame.height / 2
        routeImage.layer.borderWidth = 1
        routeImage.layer.borderColor = UIColor.clear.cgColor
        routeImage.clipsToBounds = true
        addressName.sizeToFit()
        Time.sizeToFit()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
