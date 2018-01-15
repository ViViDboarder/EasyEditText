//
//  TextDocumentViewController.swift
//  PajamaEdit
//
//  Created by Sahand on 1/14/18.
//  Copyright © 2018 Sahand Nayebaziz. All rights reserved.
//

import UIKit

class TextDocumentViewController: UIViewController {
    
    let document: Document
    
    let textView = UITextView()
    
    init(document: Document) {
        self.document = document
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didDismiss))
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
        }
    }
    
    @objc func didDismiss() {
        self.document.close(completionHandler: nil)
        dismiss(animated: true, completion: nil)
    }
}

