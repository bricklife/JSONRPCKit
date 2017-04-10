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

    let batchFactory = BatchFactory()

    func subtractAndmultiply(_ first: Int, _ second: Int) {
        let subtractRequest = Subtract(
            minuend: first,
            subtrahend: second
        )

        let multiplyRequest = Multiply(
            multiplicand: first,
            multiplier: second
        )

        let batch = batchFactory.create(subtractRequest, multiplyRequest)
        let httpRequest = MathServiceRequest(batch: batch)

        Session.send(httpRequest) { [weak self] result in
            switch result {
            case .success(let subtractAnswer, let multiplyAnswer):
                self?.subtractAnswerLabel.text = "\(subtractAnswer)"
                self?.multiplyAnswerLabel.text = "\(multiplyAnswer)"

            case .failure(let error):
                self?.subtractAnswerLabel.text = "?"
                self?.multiplyAnswerLabel.text = "?"
                self?.showAlertWithError(error)
            }
        }
    }
    
    @IBAction func didPush(_ sender: AnyObject) {
        guard let first = Int(firstTextField.text!), let second = Int(secondTextField.text!) else {
            subtractAnswerLabel.text = "?"
            multiplyAnswerLabel.text = "?"
            return
        }
        
        subtractAndmultiply(first, second)
    }
}
