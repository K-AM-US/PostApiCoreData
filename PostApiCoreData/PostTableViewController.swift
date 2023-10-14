//
//  PostTableViewController.swift
//  PostApiCoreData
//
//  Created by Mauricio Casillas on 13/10/23.
//

import UIKit
import CoreData

class PostTableViewController: UITableViewController {

    
    @IBOutlet var tableViewPosts: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let postService = PostServiceManager()
    
    var post: Post?
    var lastIndex: Int?
    var lastSegue: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let postManager = PostManager(context: context)
        
        tableViewPosts.delegate = self
        tableViewPosts.dataSource = self
        
        DispatchQueue.main.async {
            self.postService.getPosts(){ result in
                result.forEach { post in
                    _ = postManager.createPost(id: Int16(post.id!), userId: Int16(post.userId), title: post.title, body: post.body)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let postManager = PostManager(context: context)
        return postManager.getAllPosts().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postManager = PostManager(context: context)
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        
        cell.postCellTitle.text = postManager.getAllPosts()[indexPath.row].title
        cell.postCellBody.text = postManager.getAllPosts()[indexPath.row].body
        cell.id = postManager.getAllPosts()[indexPath.row].id
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postManager = PostManager(context: context)
        let cell = tableView.cellForRow(at: indexPath) as! PostCell
        post = postManager.getPost(postId: cell.id)
        performSegue(withIdentifier: "PostDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        let postManager = PostManager(context: context)
        if editingStyle == .delete{
            let cell = tableView.cellForRow(at: indexPath) as! PostCell
            
            postService.deletePost(id: Int(postManager.getPost(postId: cell.id)!.id)){ statusCode in
                if statusCode == 200 {
                    print("Post Deleted")
                } else {
                    print("error")
                }
            }
            
            _ = postManager.deletePost(post: postManager.getPost(postId: cell.id)!)
                
            tableViewPosts.reloadData()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PostDetail"){
            let destination = segue.destination as! UINavigationController
            let destinationTmp = destination.topViewController as! AddPostViewController
            destinationTmp.newPost = post
            destinationTmp.lastSegue = "PostDetail"
            destinationTmp.tableViewPosts = tableViewPosts
        }
    }
}
