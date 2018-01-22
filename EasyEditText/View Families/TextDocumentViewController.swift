//
//  TextDocumentViewController.swift
//  PajamaEdit
//
//  Created by Sahand on 1/14/18.
//  Copyright © 2018 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import SnapKit

class TextDocumentViewController: UIViewController, UITextViewDelegate, KeyboardAppearanceDelegate {
    let document: TextDocument
    
    let textView = UITextView()
    
    var keyboardObserver: NSObjectProtocol?
    
    init(document: TextDocument) {
        self.document = document
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Documents", style: .plain, target: self, action: #selector(didDismiss))
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
            make.bottom.equalTo(view.layoutMarginsGuide.snp.bottom)
            make.left.equalTo(view.readableContentGuide.snp.left)
            make.right.equalTo(view.readableContentGuide.snp.right)
        }
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.delegate = self
        
        listenForKeyboardAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        document.open { success in
            guard success else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Unable to open", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            self.title = self.document.fileURL.lastPathComponent
            self.textView.text = self.document.utf8String
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if document.utf8String.isEmpty {
            textView.becomeFirstResponder()
        }
    }
    
    @objc func didDismiss() {
        self.document.close(completionHandler: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        document.utf8String = textView.text
        document.updateChangeCount(.done)
    }
    
    func keyboardWillHide(toEndHeight height: CGFloat) {
        textView.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0)
    }
    
    func keyboardWillShow(toEndHeight height: CGFloat) {
        textView.textContainerInset = UIEdgeInsetsMake(8, 0, height + 8, 0)
    }
}

