//
//  SingleRequestViewController.swift
//  iOS Example
//
//  Created by Shinichiro Oba on 11/11/15.
//  Copyright © 2015 Shinichiro Oba. All rights reserved.
//

import UIKit
import JSONRPCKit

class SingleRequestViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var subtractAnswerLabel: UILabel!
    
    func subtract(first: Int, _ second: Int) {
        let jsonrpc = JSONRPC()
        
        let subtractRequest = Subtract(
            userName: MathServiceAPI.userName,
            APIKey: MathServiceAPI.APIKey,
            minuend: first,
            subtrahend: second
        )
        
        jsonrpc.addRequest(subtractRequest) { [weak self] result in
            switch result {
            case .Success(let answer):
                self?.subtractAnswerLabel.text = "\(answer)"
            case .Failure:
                self?.subtractAnswerLabel.text = "?"
            }
        }
        
        MathServiceAPI.request(jsonrpc)
    }
    
    @IBAction func didPush(sender: AnyObject) {
        guard let first = Int(self.firstTextField.text!), second = Int(self.secondTextField.text!) else {
            self.subtractAnswerLabel.text = "?"
            return
        }
        
        self.subtract(first, second)
    }
}

