//
//  ViewController.swift
//  Blog
//
//  Created by Sandesh on 28/04/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController{
    
    @IBOutlet weak var tableview: UITableView!
    var pageCount: Int = 1
    var blogViewModel: BlogViewModel?
    var getBlogList = [BlogElement]()
    var showBlogList = [AnyObject]()
    var refreshControl: UIRefreshControl?
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.fetchData()
        tableview?.rowHeight = UITableView.automaticDimension
        tableview?.estimatedRowHeight = 500.0
        tableview.separatorColor = .black
    }
    
    func updateView() {
        //Add refresh control for pull to refresh purpose
        self.refreshControl = UIRefreshControl.init()
        self.refreshControl?.addTarget(self, action: #selector(ViewController.fetchData), for: .valueChanged)
        self.tableview?.addSubview(refreshControl!)
        self.tableview?.allowsSelection = false

        self.tableview.reloadData()
    }
    
    // MARK: - To get API data
    @objc func fetchData(){
        if isConnectedToInternet() == true {
            BlogViewModel.getdat(page: pageCount) { (blog) in
                self.refreshControl?.endRefreshing()
                
                self.blogViewModel = BlogViewModel.init(blog: blog ?? [])
                self.getBlogList = self.blogViewModel?.blog ?? []
                
                for blog in self.getBlogList {
                    self.createData(blog: blog)
                }
                self.retrieveData()
                
                DispatchQueue.main.async {
                    self.updateView()
                }
            }
        }
        else {
            if entityIsEmpty(entity: blogLocalDataEntity){
                showAlert(title: "No Internet Connection", message: "Please check your internet connection")
            }
            else{
                showAlert(title: "No Internet Connection", message: "Showing offline data")
                self.retrieveData()
                DispatchQueue.main.async {
                    self.updateView()
                }
            }
        }
        
    }
    
    // MARK: - CORE DATA CRUD
    func createData(blog: BlogElement){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: blogLocalDataEntity, in: managedContext)!
        
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: blogLocalDataEntity)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as? [NSManagedObject] ?? [] {
                self.showBlogList.append(data)
            }
        } catch {
            print("Failed")
        }
        self.refreshControl?.endRefreshing()

    }
    
    func entityIsEmpty(entity: String) -> Bool
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var results : NSArray?
        
        do {
            results = try context.fetch(request) as? [NSManagedObject] as NSArray?
            return results!.count == 0
        } catch let error as NSError {
            // failure
            print("Error: \(error.debugDescription)")
            return true
        }
    }
}
