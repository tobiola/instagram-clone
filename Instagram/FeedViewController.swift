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

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts: [QueryDocumentSnapshot] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
        // return number of posts viewed
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        
        
        let post = self.posts[indexPath.row].data()
        
        let imageUrl = URL(string: post["url"] as! String)!

        cell.authorLabel.text = post["author"] as? String
        cell.captionLabel.text = post["caption"] as? String
        // cell.photoView.af_setImage(withURL: imageUrl)
       
        cell.photoView.af_setImage(withURL: imageUrl, placeholderImage: UIImage(named: "image_placeholder"), completion: { (response) in
            cell.photoView.image = response.result.value
        })
        
        return cell
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
