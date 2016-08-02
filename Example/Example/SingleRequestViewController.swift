//
//  SingleRequestViewController.swift
//  iOS Example
//
//  Created by Shinichiro Oba on 11/11/15.
//  Copyright © 2015 Shinichiro Oba. All rights reserved.
//

import UIKit
import APIKit
import JSONRPCKit

public struct StringIdGenerator: IdGeneratorType {

    private var currentId = 1
    
    public mutating func next() -> Id {
        defer {
            currentId += 1
        }
        
        return .String("id\(currentId)")
    }
}

class SingleRequestViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var subtractAnswerLabel: UILabel!

    let batchFactory = BatchFactory(version: "2.0", idGenerator: StringIdGenerator())

    func subtract(first: Int, _ second: Int) {
        let divideRequest = Divide(
            dividend: first,
            divisor: second
        )

        let batch = batchFactory.create(divideRequest)
        let httpRequest = MathServiceRequest(batch: batch)

        Session.sendRequest(httpRequest) { [weak self] result in
            switch result {
            case .Success(let answer):
                self?.subtractAnswerLabel.text = "\(answer)"
                
            case .Failure(let error):
                self?.subtractAnswerLabel.text = "?"
                self?.showAlertWithError(error)
            }
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

