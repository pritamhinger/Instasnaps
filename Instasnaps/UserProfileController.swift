//
//  UserProfileController.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 31/12/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserProfileController: UICollectionViewController {
    
    let headerReusableIdentifier = "headerId"
    let cellReusableIdentifier = "cellId"
    var user: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReusableIdentifier)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReusableIdentifier)
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            print(snapshot.value ?? "Value is nil or empty")
            guard let userProfileDictionary = snapshot.value as? [String: Any] else {return}
            
            self.user = UserProfile(dictionary: userProfileDictionary)
            self.navigationItem.title = self.user?.username
            self.collectionView?.reloadData()
            
        }, withCancel: {(error) in
            print("Error occred while reading user profile")
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReusableIdentifier, for: indexPath)
        cell.backgroundColor = .purple
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2)/3
        return CGSize(width: width, height: width)
    }
    
    
}

extension UserProfileController: UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReusableIdentifier, for: indexPath) as! UserProfileHeader
        headerCell.user = user
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}
