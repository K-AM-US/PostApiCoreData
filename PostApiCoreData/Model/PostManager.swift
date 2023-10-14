//
//  PostManager.swift
//  PostApiCoreData
//
//  Created by Mauricio Casillas on 13/10/23.
//

import Foundation
import CoreData

class PostManager {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    
    
//    Create Post
    func createPost(id: Int16, userId: Int16, title: String, body: String) -> Post?{
        let newPost = Post(context: context)
        
        newPost.id = id
        newPost.userId = userId
        newPost.title = title
        newPost.body = body
        
        do {
            try context.save()
            return newPost
        }catch let error {
            print("error: ", error)
            return nil
        }
    }
    
    
    
    
//    Readd Post
    func getAllPosts() -> [Post] {
        if let posts = try? self.context.fetch(Post.fetchRequest()) {
            return posts
        }else {
            return []
        }
    }
    
    func getPost(postId: Int16) -> Post? {
        let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
        var predicate: NSPredicate?
        
        predicate = NSPredicate(format: "id = %d", postId as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let post = try context.fetch(fetchRequest)
            return post.first
        }catch let error {
            print("error: ", error)
            return nil
        }
    }
    
    
    
    
//    Update Post
    func updatePost(post: Post, title: String, body: String) {
        post.title = title
        post.body = body
        
        do {
            try context.save()
        } catch let error {
            print("error: ", error)
        }
    }
    
    
    
    
//    Delete Song
    func deletePost(post: Post) -> Bool {
        self.context.delete(post)
            
        do {
            try context.save()
            return true
        } catch let error {
            print("error: ", error)
            return false
        }
    }
}
