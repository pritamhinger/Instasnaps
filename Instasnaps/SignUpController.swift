//
//  ViewController.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 26/12/17.
//  Copyright © 2017 AppDevelapp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpController: UIViewController {

    let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(selectProfileImage), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextFieldTextChanged), for: .editingChanged)
        return textField
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextFieldTextChanged), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextFieldTextChanged), for: .editingChanged)
        return textField
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(addPhotoButton)
        view.addSubview(emailTextField)
        
        addPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, topPadding: 40, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 140, height: 140)
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setUpInputFields()
    }
    
    fileprivate func setUpInputFields(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signupButton])

        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topPadding: 20, leftPadding: 40, bottomPadding: 0, rightPadding: 40, width: 0, height: 200)
    }
    
    @objc private func handleSignUp(){
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user: User?, error: Error?) -> Void in
            if let err = error{
                print(err)
                return
            }
            
            print("Successfully created user for authentication. User Id is : \(user?.uid ?? "")")

            guard let image = self.addPhotoButton.imageView?.image else {return}
            
            guard let imageData = UIImageJPEGRepresentation(image, 0.3) else {return}
            
            let fileName = NSUUID().uuidString
            Storage.storage().reference().child("profileImages").child(fileName).putData(imageData, metadata: nil, completion: {(metadata, error) in
                if let error = error{
                    print("Failed to upload profile image", error)
                    return
                }
                
                print("Successfully uploaded the profile image")
                guard let imageUrl = metadata?.downloadURL()?.absoluteString else {return}
                print("Image URL is : \(imageUrl)")
                
                guard let uid = user?.uid else {return}
                
                let userProfileAttributes = ["username": username, "profileImageURL": imageUrl]
                let userValues = [uid: userProfileAttributes]
                
                Database.database().reference().child("users").updateChildValues(userValues, withCompletionBlock: {(error, reference) in
                    if let error = error {
                        print("Error occured while saving user profile", error)
                        return
                    }
                    
                    print("USer Profile saved in Firebase Database")
                })
            })
            
            
        })
    }
    
    @objc private func handleTextFieldTextChanged(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0 &&
        usernameTextField.text?.count ?? 0 > 0 &&
        passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid{
            signupButton.isEnabled = true
            signupButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }else{
            signupButton.isEnabled = false
            signupButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc func selectProfileImage(){
        let imageViewController = UIImagePickerController()
        imageViewController.delegate = self
        imageViewController.allowsEditing = true
        present(imageViewController, animated: true, completion: nil)
    }
}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            addPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            addPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width/2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.borderColor = UIColor.black.cgColor
        addPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Action canceled by user")
    }
}
