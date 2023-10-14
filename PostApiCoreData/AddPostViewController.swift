//
//  AddNoteViewController.swift
//  PostApiCoreData
//
//  Created by Mauricio Casillas on 13/10/23.
//

import UIKit

class AddPostViewController: UIViewController {
    
    @IBOutlet var postTitleCell: UITextView!
    @IBOutlet var postBodyCell: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let postService = PostServiceManager()
    
    var newPost: Post?
    let alert = EmptyFieldAlert()
    
    var lastIndex: Int?
    var lastSegue: String?
    var tableViewPosts: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTitleCell.text = newPost?.title
        postBodyCell.text = newPost?.body
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if(!postTitleCell.text.isEmpty && !postBodyCell.text.isEmpty){
            
            let postManager = PostManager(context: context)
            if(lastSegue == "PostDetail") {
                print("se actualiza")
                postManager.updatePost(post: newPost!, title: postTitleCell.text, body: postBodyCell.text)
                postService.updatePost(post: PostApi(id: Int(newPost!.id), title: postTitleCell.text, body: postBodyCell.text, userId: Int(newPost!.userId))){ updatedPost in
                    print("Updated Post: ", updatedPost as Any)
                }
                tableViewPosts?.reloadData()
            } else {
                print("se crea")
                
                let post = postManager.createPost(id: Int16.random(in: 100...300), userId: Int16(8), title: postTitleCell.text, body: postBodyCell.text)
                tableViewPosts?.reloadData()
                postService.createPost(post: PostApi(id: Int(post!.id), title: (post?.title)!, body: post!.body!, userId: Int(post!.userId))) { post in
                    print("post creado: ", post as Any)
                }
                tableViewPosts?.reloadData()
                
            }
            
            self.dismiss(animated: true, completion: nil)
        } else {
            alert.showAlert(with: "Empty Fields!",
                            message: "Please fill all the \nfields to save the note.",
                            on: self)
        }
    }
    
    @objc func dismissAlert(){
        alert.dismissAlert()
    }

}

class EmptyFieldAlert {
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        return alert
    }()
    
    private var globalTargetView: UIView?
    
    func showAlert(with title: String,
                   message: String,
                   on ViewController: UIViewController){
        
        guard let targetView = ViewController.view else{
            return
        }
        
        globalTargetView = targetView
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        alertView.frame = CGRect(x: 40,
                                 y: -300,
                                 width: targetView.frame.size.width-80,
                                 height: 300)
        
        let titleLabel = UILabel(frame: CGRect(x:0,
                                               y:0,
                                               width: alertView.frame.size.width,
                                               height: 80))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)
        
        let messageLabel = UILabel(frame: CGRect(x:0,
                                                 y:80,
                                                 width: alertView.frame.size.width,
                                                 height: 170))
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        messageLabel.textAlignment = .center
        alertView.addSubview(messageLabel)
        
        let dismissBtn = UIButton(frame: CGRect(x: 0,
                                                y: alertView.frame.size.height-50,
                                                width: alertView.frame.size.width,
                                                height: 50))
        
        alertView.addSubview(dismissBtn)
        dismissBtn.setTitle("Dismiss", for: .normal)
        dismissBtn.setTitleColor(.link, for: .normal)
        dismissBtn.addTarget(self,
                             action: #selector(dismissAlert),
                             for: .touchUpInside)
        
        UIView.animate(withDuration: 0.25,
                       animations: {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        }, completion: { done in
            if done{
                UIView.animate(withDuration: 0.25, animations: {
                    self.alertView.center = targetView.center
                })
            }
            
        })
    }
    
    @objc func dismissAlert(){
        
        guard let targetView = globalTargetView else {
            return
        }
        
        UIView.animate(withDuration: 0.25,
                       animations: {
            self.alertView.frame = CGRect(x: 40,
                                          y: targetView.frame.size.height,
                                          width: targetView.frame.size.width-80,
                                          height: 300)
        }, completion: { done in
            if done{
                UIView.animate(withDuration: 0.25, animations: {
                    self.backgroundView.alpha = 0
                }, completion: { done in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                })
            }
            
        })
    }
}

