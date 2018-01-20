//
//  SharePhotoController.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 06/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    static let updateFeedNotificatioName = Notification.Name("updateFeed")
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .orange
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let shareTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    var selectedImage: UIImage? {
        didSet{
            imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setUpControls()
    }
    
    func setUpControls() {
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        containerView.addSubview(shareTextView)
        
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topPadding: 8, leftPadding: 8, bottomPadding: 8, rightPadding: 0, width: 84, height: 0)
        shareTextView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topPadding: 0, leftPadding: 4, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @objc func handleShare(){
        guard let caption = shareTextView.text, caption.count > 0 else { return }
        guard let image = selectedImage else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 0.2) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let fileName = NSUUID().uuidString
        Storage.storage().reference().child("posts").child(fileName).putData(imageData, metadata: nil) { (metadata, err) in
            if let err = err {
                print("Error occured while uploading image", err)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
            self.savePostWithURL(imageUrl: imageUrl)
        }
    }
    
    fileprivate func savePostWithURL(imageUrl: String){
        guard let caption = shareTextView.text else { return}
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let image = selectedImage else { return }
        
        let postDictionary = ["postImageUrl": imageUrl, "caption": caption, "imageWidth": image.size.width, "imageHeight": image.size.height, "createdOn": Date().timeIntervalSince1970] as [String : Any]
        let userPostsRef = Database.database().reference().child("posts").child(uid)
        let postRef = userPostsRef.childByAutoId()
        postRef.updateChildValues(postDictionary) { (error, referece) in
            if let error = error {
                print("Error coccured while saving the post in DB", error)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            
            print("Post saved successfully in DB")
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificatioName, object: nil)
        }
    }
}
