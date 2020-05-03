//
//  ViewController+TableView+Extension.swift
//  Blog
//
//  Created by Sandesh on 03/05/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.showBlogList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var blogCell: BlogCell? = tableView.dequeueReusableCell(withIdentifier: blogCellId, for: indexPath) as? BlogCell
        
        blogCell?.layer.cornerRadius = 10
        
        if blogCell == nil {
            blogCell = BlogCell.init(style: .default, reuseIdentifier: blogCellId)
        }
        blogCell?.lblUserName.text = self.showBlogList[indexPath.row].value(forKey: "username") as? String
        blogCell?.lblBlogTitle.text = self.showBlogList[indexPath.row].value(forKey: "blogtitle") as? String
        blogCell?.imgAvatar.loadImageUsingCache(withUrl: self.showBlogList[indexPath.row].value(forKey: "avatar") as? String ?? "")
        if self.showBlogList[indexPath.row].value(forKey: "blogimage") as! String != "-" {
            blogCell?.imgBlog.loadImageUsingCache(withUrl: self.showBlogList[indexPath.row].value(forKey: "blogimage") as! String)
            blogCell?.blogImgHC.constant = 100
        }
        else{
            blogCell?.blogImgHC.constant = 0
        }
       
        blogCell?.lblUserDesignation.text = self.showBlogList[indexPath.row].value(forKey: "userdesignation") as? String
        blogCell?.lblBlogLikes.text = Double("\(self.showBlogList[indexPath.row].value(forKey: "likes") ?? "0")")!.kmFormatted + " Likes"
        blogCell?.lblComments.text = Double("\(self.showBlogList[indexPath.row].value(forKey: "comments") ?? "0")")!.kmFormatted + " Comments"
        
        blogCell?.lblBlogURL.text = self.showBlogList[indexPath.row].value(forKey: "blogurl") as? String
        blogCell?.lblBlogContent.text = self.showBlogList[indexPath.row].value(forKey: "blogcontent") as? String
        
        let createDate = "\(self.showBlogList[indexPath.row].value(forKey: "blogtime") ?? "")"
        blogCell?.lblBlogTime.text = formatDate(date: createDate)
        
        return blogCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


