//
//  HackerNewsTableViewCell.swift
//  HackerNews
//
//  Created by Numeric on 3/6/18.
//  Copyright © 2018 Numeric. All rights reserved.
//

import UIKit

class HackerNewsTableViewCell: UITableViewCell {
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var articleVote: UILabel!
    @IBOutlet weak var articleTime: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
