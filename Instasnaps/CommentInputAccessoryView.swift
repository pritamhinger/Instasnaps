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
    
    let commentTextField: CommentInputView = {
        let tv = CommentInputView()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
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
        
        autoresizingMask = .flexibleHeight
        
        backgroundColor = .white
        
        addSubview(submitButton)
        addSubview(commentTextField)
        
        submitButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 12, width: 50, height: 50)
        commentTextField.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, topPadding: 8, leftPadding: 12, bottomPadding: 8, rightPadding: 0, width: 0, height: 0)
        setUpLineSeparatorView()
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
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
        commentTextField.showPlaceHolderLabel()
    }
}
