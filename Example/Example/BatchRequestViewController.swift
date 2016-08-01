//
//  BatchRequestViewController.swift
//  JSONRPCKit
//
//  Created by Shinichiro Oba on 2015/11/11.
//  Copyright © 2015年 Shinichiro Oba. All rights reserved.
//

import UIKit
import JSONRPCKit
import APIKit

class BatchRequestViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var subtractAnswerLabel: UILabel!
    @IBOutlet weak var multiplyAnswerLabel: UILabel!

    let callFactory = CallBatchFactory(version: "2.0", idGenerator: StringIdGenerator())

    func subtractAndmultiply(first: Int, _ second: Int) {
        let subtractRequest = Subtract(
            minuend: first,
            subtrahend: second
        )

        let multiplyRequest = Multiply(
            multiplicand: first,
            multiplier: second
        )

        let callBatch = callFactory.create(subtractRequest, multiplyRequest)
        let httpRequest = MathServiceRequest(callBatch: callBatch)

        Session.sendRequest(httpRequest) { [weak self] result in
            switch result {
            case .Success(let subtractAnswer, let multiplyAnswer):
                self?.subtractAnswerLabel.text = "\(subtractAnswer)"
                self?.multiplyAnswerLabel.text = "\(multiplyAnswer)"

            case .Failure(let error):
                self?.subtractAnswerLabel.text = "?"
                self?.multiplyAnswerLabel.text = "?"
                self?.showAlertWithError(error)
            }
        }
    }
    
    @IBAction func didPush(sender: AnyObject) {
        guard let first = Int(firstTextField.text!), second = Int(secondTextField.text!) else {
            subtractAnswerLabel.text = "?"
            multiplyAnswerLabel.text = "?"
            return
        }
        
        subtractAndmultiply(first, second)
    }
}
