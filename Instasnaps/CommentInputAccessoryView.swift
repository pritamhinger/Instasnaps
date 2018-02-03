//
//  CommentInputAccessoryView.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 03/02/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmitComment(withText text:String);
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your comment here..!!"
        return textField
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleCommentSubmit), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(submitButton)
        addSubview(commentTextField)
        
        submitButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 12, width: 50, height: 0)
        commentTextField.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: submitButton.leftAnchor, topPadding: 0, leftPadding: 12, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
        setUpLineSeparatorView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder) is not implemented")
    }
    
    @objc func handleCommentSubmit(){
        print(123)
        guard let commentText = commentTextField.text else { return }
        
        delegate?.didSubmitComment(withText: commentText)
    }
    
    fileprivate func setUpLineSeparatorView(){
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 1)
    }
    
    func clearCommentTextField(){
        commentTextField.text = nil
    }
}
