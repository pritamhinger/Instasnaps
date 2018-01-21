//
//  CommentController.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 21/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase

class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var post: Post?
    var comments = [Comment]()
    let commentCellId = "CommentCellIdentifier"
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your comment here..!!"
        return textField
    }()
    
    lazy var containerView: UIView = {
        let commentView = UIView()
        commentView.backgroundColor = .white
        commentView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleCommentSubmit), for: .touchUpInside)
        commentView.addSubview(submitButton)
        
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        commentView.addSubview(self.commentTextField)
        commentView.addSubview(lineSeparatorView)
        self.commentTextField.layer.cornerRadius = 5
        submitButton.anchor(top: commentView.topAnchor, left: nil, bottom: commentView.bottomAnchor, right: commentView.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 12, width: 50, height: 0)
        self.commentTextField.anchor(top: commentView.topAnchor, left: commentView.leftAnchor, bottom: commentView.bottomAnchor, right: submitButton.leftAnchor, topPadding: 0, leftPadding: 12, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
        lineSeparatorView.anchor(top: commentView.topAnchor, left: commentView.leftAnchor, bottom: nil, right: commentView.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 1)
        return commentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        collectionView?.backgroundColor = .white
        //collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        //collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: commentCellId)
        
        fetchCommentsForPost()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellId, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = self.comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(8 + 40 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    @objc fileprivate func handleCommentSubmit(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = post?.postId else { return }
        guard let commentText = commentTextField.text else { return }
        let values: [String : Any] = ["commentText" : commentText,
                                      "commentedOn" : Date().timeIntervalSince1970,
                                      "commentedByUserId" : uid]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error, reference) in
            if let error = error{
                print("error occured while saving comment", error)
                return
            }
            
            self.commentTextField.text = nil
        }
    }
    
    fileprivate func fetchCommentsForPost() {
        guard let postId = self.post?.postId else { return }
        let postCommentsRef = Database.database().reference().child("comments").child(postId)
        postCommentsRef.observe(.childAdded, with: { (snapshot) in
            
            guard let commentJSON = snapshot.value as? [String : Any] else { return }
            guard let uid = commentJSON["commentedByUserId"] as? String else { return }
            
            Database.fetchUserWithUID(uid: uid, onCompletionHandler: { (user) in
                let comment = Comment(user: user, commentJSON: commentJSON)
                self.comments.append(comment)
                self.collectionView?.reloadData()
                let indexPath = IndexPath(row: self.comments.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            })
            
        }) { (error) in
            print("Error occured while fetching comments for the post", error)
        }
    }
}
