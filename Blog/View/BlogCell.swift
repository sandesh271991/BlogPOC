//
//  BlogCell.swift
//  Blog
//
//  Created by Sandesh on 29/04/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit

class BlogCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserDesignation: UILabel!
    @IBOutlet weak var lblBlogTime: UILabel!
    @IBOutlet weak var imgBlog: UIImageView!
    @IBOutlet weak var lblBlogContent: UILabel!
    @IBOutlet weak var lblBlogTitle: UILabel!
    @IBOutlet weak var lblBlogURL: UILabel!
    @IBOutlet weak var lblBlogLikes: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    
    @IBOutlet weak var blogImgHC: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgAvatar.layer.cornerRadius = 25

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

