//
//  BatchRequestViewController.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/11.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import UIKit
import JSONRPCKit

class BatchRequestViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var subtractAnswerLabel: UILabel!
    @IBOutlet weak var multiplyAnswerLabel: UILabel!
    
    func subtractAndmultiply(first: Int, _ second: Int) {
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
        
        let multiplyRequest = Multiply(
            userName: MathServiceAPI.userName,
            APIKey: MathServiceAPI.APIKey,
            multiplicand: first,
            multiplier: second
        )
        
        jsonrpc.addRequest(multiplyRequest) { [weak self] result in
            switch result {
            case .Success(let answer):
                self?.multiplyAnswerLabel.text = "\(answer)"
            case .Failure:
                self?.multiplyAnswerLabel.text = "?"
            }
        }
        
        MathServiceAPI.request(jsonrpc) { [weak self] error in
            let alert = UIAlertController(title: error.localizedDescription, message: error.localizedRecoverySuggestion, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self?.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func didPush(sender: AnyObject) {
        guard let first = Int(self.firstTextField.text!), second = Int(self.secondTextField.text!) else {
            self.subtractAnswerLabel.text = "?"
            self.multiplyAnswerLabel.text = "?"
            return
        }
        
        self.subtractAndmultiply(first, second)
    }
}
