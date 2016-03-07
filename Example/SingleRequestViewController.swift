//
//  SingleRequestViewController.swift
//  iOS Example
//
//  Created by Shinichiro Oba on 11/11/15.
//  Copyright © 2015 Shinichiro Oba. All rights reserved.
//

import UIKit
import JSONRPCKit

public class StringIdentifierGenerator: RequestIdentifierGenerator {
    
    private var currentIdentifier = 1
    
    public func next() -> RequestIdentifier {
        return .StringIdentifier("id\(currentIdentifier++)")
    }
}


class SingleRequestViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var subtractAnswerLabel: UILabel!
    
    func subtract(first: Int, _ second: Int) {
        let jsonrpc = JSONRPC(identifierGenerator: StringIdentifierGenerator())
        
        let subtractRequest = Divide(
            userName: MathServiceAPI.userName,
            APIKey: MathServiceAPI.APIKey,
            dividend: first,
            divisor: second
        )
        
        jsonrpc.addRequest(subtractRequest) { [weak self] result in
            switch result {
            case .Success(let answer):
                self?.subtractAnswerLabel.text = "\(answer)"
                
            case .Failure(let error):
                self?.subtractAnswerLabel.text = "?"
                if case .RequestError(_, let message, let data as String) = error {
                    let alert = UIAlertController(title: message, message: data, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self?.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        
        MathServiceAPI.request(jsonrpc) { [weak self] error in
            let alert = UIAlertController(title: error.localizedDescription, message: error.localizedRecoverySuggestion, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self?.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func didPush(sender: AnyObject) {
        guard let first = Int(firstTextField.text!), second = Int(secondTextField.text!) else {
            subtractAnswerLabel.text = "?"
            return
        }
        
        subtract(first, second)
    }
}

