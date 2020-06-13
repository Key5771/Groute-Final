//
//  RouteListTableViewCell.swift
//  Groute
//
//  Created by 김기현 on 2020/06/02.
//  Copyright © 2020 김기현. All rights reserved.
//

import UIKit

class RouteListTableViewCell: UITableViewCell {
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
