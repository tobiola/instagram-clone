//
//  PostCell.swift
//  Instagram
//
//  Created by Tobi Ola on 2/18/19.
//  Copyright © 2019 Tobi Ola. All rights reserved.
//

import UIKit
import AlamofireImage

class PostCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
