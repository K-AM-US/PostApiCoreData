//
//  PostServiceManager.swift
//  PostApiCoreData
//
//  Created by Mauricio Casillas on 13/10/23.
//

import Foundation

class PostServiceManager {
    
    private var loadedPosts: [PostApi] = []
    
    static let shared = PostServiceManager()
    init(){}
    
    
    func countPosts() -> Int {
        return loadedPosts.count
    }
    
    func getPost(at index: Int) -> PostApi {
        return loadedPosts[index]
    }
    
    
//    Create Post
    func createPost(post: PostApi, completion: @escaping (PostApi?) -> Void) {
        guard let url = URL(string: Constants.postUrl) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(post)
            
            print("JSON:", try JSONSerialization.jsonObject(with: jsonData))
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    if let createdPost = try? JSONDecoder().decode(PostApi.self, from: data) {
                        completion(createdPost)
                    }
                } else if let error = error {
                    print("error: ", error)
                    completion(nil)
                }
            }
            task.resume()
        } catch let error {
            print("error: ", error)
            completion(nil)
        }
    }
    
    

//    Read Posts
    func getPosts(completion: @escaping ([PostApi]) -> Void) {
        guard let url = URL(string: Constants.postUrl) else {
            return 
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            let decoder = JSONDecoder()
            
            if let data = data {
                do {
                    let tasks = try decoder.decode([PostApi].self, from: data)
                    completion(tasks)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    
    
//    Update Post
    func updatePost(post: PostApi, completion: @escaping (PostApi?) -> Void) {
        let urlString = Constants.postUrl + String(post.id!)
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(post)
            print("JSON: ", try JSONSerialization.jsonObject(with: jsonData))
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    if let updatedPost = try? JSONDecoder().decode(PostApi.self, from: data) {
                        completion(updatedPost)
                    }
                } else if let error = error {
                    print("error: ", error)
                    completion(nil)
                }
            }
            task.resume()
        } catch let error {
            print("error: ", error)
            completion(nil)
        }
    }
    
    
    
//    Delete Post
    func deletePost(id: Int, completion: @escaping (Int) -> Void) {
        let urlString = Constants.postUrl + String(id)
        
        guard let url = URL(string: urlString) else {
            completion(0)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completion(response.statusCode)
            } else if let error = error {
                print("error: ", error)
                completion(0)
            }
        }
        task.resume()
    }
    
}
