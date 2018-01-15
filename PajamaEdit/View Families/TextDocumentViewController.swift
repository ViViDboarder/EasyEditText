//
//  TextDocumentViewController.swift
//  PajamaEdit
//
//  Created by Sahand on 1/14/18.
//  Copyright © 2018 Sahand Nayebaziz. All rights reserved.
//

import UIKit
import SnapKit

class TextDocumentViewController: UIViewController, UITextViewDelegate {
    
    let document: TextDocument
    
    let textView = UITextView()
    
    init(document: TextDocument) {
        self.document = document
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didDismiss))
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
        }
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.delegate = self
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
    
    @objc func didDismiss() {
        self.document.close(completionHandler: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        document.utf8String = textView.text
        document.updateChangeCount(.done)
    }
}

