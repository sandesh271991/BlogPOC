//
//  ViewController.swift
//  Blog
//
//  Created by Sandesh on 28/04/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    fileprivate var tasks = [URLSessionTask]()
    var pageCount: Int = 1
    
    var blogViewModel: BlogViewModel?
    
    var getBlogList = [BlogElement]()
    var showBlogList = [AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.fetchData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableview?.rowHeight = UITableView.automaticDimension
        tableview?.estimatedRowHeight = 500.0
    }
    
    func fetchData(){
        BlogViewModel.getdat(page: pageCount) { (blog) in
            self.blogViewModel = BlogViewModel.init(blog: blog ?? [])
            self.getBlogList = self.blogViewModel?.blog ?? []
            
            for blog in self.getBlogList {
                self.createData(blog: blog)
            }
            
            self.retrieveData()
            self.updateView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getBlogList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var blogCell: BlogCell? = tableView.dequeueReusableCell(withIdentifier: "blogCell", for: indexPath) as? BlogCell
        
        if blogCell == nil {
            blogCell = BlogCell.init(style: .default, reuseIdentifier: "blogCell")
        }
        
        blogCell?.lblUserName.text = self.showBlogList[indexPath.row].value(forKey: "username") as? String
        blogCell?.lblBlogTitle.text = self.showBlogList[indexPath.row].value(forKey: "blogtitle") as? String
        blogCell?.imgAvatar.loadImageUsingCache(withUrl: self.showBlogList[indexPath.row].value(forKey: "avatar") as? String ?? "")
        blogCell?.imgBlog.loadImageUsingCache(withUrl: self.showBlogList[indexPath.row].value(forKey: "blogimage") as? String ?? "")
        
        blogCell?.lblUserDesignation.text = self.showBlogList[indexPath.row].value(forKey: "userdesignation") as? String
        blogCell?.lblBlogLikes.text = "\(self.showBlogList[indexPath.row].value(forKey: "likes") ?? "") Likes"
        blogCell?.lblComments.text = "\(self.showBlogList[indexPath.row].value(forKey: "comments") ?? "") Commnets"
        blogCell?.lblBlogURL.text = self.showBlogList[indexPath.row].value(forKey: "blogurl") as? String
        
        blogCell?.lblBlogContent.text = self.showBlogList[indexPath.row].value(forKey: "blogcontent") as? String
        blogCell?.lblBlogTime.text = self.showBlogList[indexPath.row].value(forKey: "blogtime") as? String
        
        return blogCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //CORE DATA CRUD
    func createData(blog: BlogElement){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "Blogs", in: managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue( blog.comments , forKeyPath: "comments")
        user.setValue( blog.likes , forKeyPath: "likes")
        user.setValue( blog.content , forKeyPath: "blogcontent")
        
        if blog.user.count > 0 {
            user.setValue( blog.user[0].avatar , forKeyPath: "avatar")
            user.setValue( blog.user[0].createdAt , forKeyPath: "blogtime")
            user.setValue( blog.user[0].designation , forKeyPath: "userdesignation")
            user.setValue( blog.user[0].name , forKeyPath: "username")
        }
        else {
            user.setValue( "-" , forKeyPath: "avatar")
            user.setValue( "-" , forKeyPath: "blogtime")
            user.setValue( "-", forKeyPath: "userdesignation")
            user.setValue( "-" , forKeyPath: "username")
        }
        
        if blog.media.count > 0 {
            user.setValue( blog.media[0].title , forKeyPath: "blogtitle")
            user.setValue( blog.media[0].url , forKeyPath: "blogurl")
            user.setValue( blog.media[0].image , forKeyPath: "blogimage")
            
        }
        else {
            user.setValue( "-" , forKeyPath: "blogtitle")
            user.setValue( "-" , forKeyPath: "blogurl")
            user.setValue( "-" , forKeyPath: "blogimage")
        }
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func retrieveData() {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Blogs")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "comments"))
                print(data.value(forKey: "avatar"))
                print(data.value(forKey: "blogtitle"))
                self.showBlogList.append(data)
            }
        } catch {
            print("Failed")
        }
    }
    
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            pageCount += 1
            self.fetchData()
        }
    }
    
    func updateView() {
        self.tableview.reloadData()
    }
    
    // MARK: - Image downloading
    
    fileprivate func downloadImage(forItemAtIndex index: Int) {
        let url = URL(fileURLWithPath: "\(self.blogViewModel?.blog?[index].user[0].avatar ?? "")")
        guard tasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil else {
            // We're already downloading the image.
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Perform UI changes only on main thread.
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    // self.items[index].image = image
                    
                    // Reload cell with fade animation.
                    let indexPath = IndexPath(row: index, section: 0)
                    if let cell = self.tableview.cellForRow(at: indexPath) as? BlogCell {
                        cell.imgAvatar.image = image
                    }
                    
                    if self.tableview.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                        self.tableview.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    }
                }
            }
        }
        task.resume()
        tasks.append(task)
    }
    
    fileprivate func cancelDownloadingImage(forItemAtIndex index: Int) {
        let url = URL(fileURLWithPath: "\(self.blogViewModel?.blog?[index].user[0].avatar ?? "")")
        // Find a task with given URL, cancel it and delete from `tasks` array.
        guard let taskIndex = tasks.firstIndex(where: { $0.originalRequest?.url == url }) else {
            return
        }
        let task = tasks[taskIndex]
        task.cancel()
        tasks.remove(at: taskIndex)
    }
}


let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
            
        }).resume()
    }
}
