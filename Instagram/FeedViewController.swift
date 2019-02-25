//
//  FeedViewController.swift
//  Instagram
//
//  Created by Tobi Ola on 2/18/19.
//  Copyright © 2019 Tobi Ola. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import Alamofire
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    var posts: [QueryDocumentSnapshot] = []
    var selectedPost: QueryDocumentSnapshot!
    let refreshPosts = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        tableView.keyboardDismissMode = .interactive
        
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (snapshot, error) in
            if let _ = error {
                print("error has occured")
            } else {
                self.posts = snapshot!.documents
                self.tableView.reloadData()
            }
        }
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        refresh()
        refreshPosts.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshPosts

    }
    
    @objc func refresh() {
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (snapshot, error) in
            if let _ = error {
                print("error has occured")
            } else {
                self.posts = snapshot!.documents
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (snapshot, error) in
            if let _ = error {
                print("error has occured")
            } else {
                self.posts = snapshot!.documents
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        do {
        try Auth.auth().signOut()
        } catch {
            print("error logging out")
        }
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
        
        
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        var comment = text
        comment = (Auth.auth().currentUser!.displayName ?? "") + ": " + comment
        
        let db = Firestore.firestore()
 db.collection("posts").document(selectedPost.documentID).updateData([
            "comments": FieldValue.arrayUnion([comment])
            ])
        
        self.tableView.reloadData()
        
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = post.data()["comments"] as? [String] ?? []
        return comments.count + 2
        // return number of posts viewed
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let post = self.posts[indexPath.section]
        let comments = post.data()["comments"] as? [String] ?? []
        
    
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            let imageUrl = URL(string: post["url"] as! String)!

            cell.authorLabel.text = post.data()["author"] as? String
            cell.captionLabel.text = post.data()["caption"] as? String
            // cell.photoView.af_setImage(withURL: imageUrl)
       
            cell.photoView.af_setImage(withURL: imageUrl, placeholderImage: UIImage(named: "image_placeholder"), completion: { (response) in
                cell.photoView.image = response.result.value
            })
        
            return cell
        } else if indexPath.row == comments.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            cell.commentLabel.text = comments[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let post = posts[indexPath.section]
        let comments = post.data()["comments"] as? [String] ?? []
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
        commentBar.inputTextView.becomeFirstResponder()
            selectedPost = post

        } else {

            showsCommentBar = false
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
