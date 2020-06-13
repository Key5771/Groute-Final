//
//  ContentRouteTableViewCell.swift
//  Groute
//
//  Created by 이민재 on 13/06/2020.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit

class ContentRouteTableViewCell: UITableViewCell {

    @IBOutlet var routeIndex: UILabel!
    @IBOutlet var locationName: UILabel!
    @IBOutlet var reviewButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        routeIndex.sizeToFit()
        locationName.sizeToFit()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
