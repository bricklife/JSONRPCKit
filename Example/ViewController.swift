//
//  ViewController.swift
//  iOS Example
//
//  Created by Shinichiro Oba on 11/11/15.
//  Copyright © 2015 Shinichiro Oba. All rights reserved.
//

import UIKit
import JSONRPCKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func subtract(minuend: Int, _ subtrahend: Int) {
        // https://jsonrpcx.org/AuthX/Cookbook

        let subtractRequest = Subtract(
            userName: "jenolan",
            APIKey: "qIQlg9S28mbK2Iolm8yffr97Yp6zMxiF",
            minuend: minuend,
            subtrahend: subtrahend)
        
        let jsonrpc = JSONRPC()
        
        jsonrpc.addRequest(subtractRequest) { result in
            switch result {
            case .Success(let answer):
                self.answerLabel.text = "\(answer)"
            case .Failure:
                self.answerLabel.text = "?"
            }
        }
        
        let URLRequest = NSMutableURLRequest()
        URLRequest.URL = NSURL(string: "https://jsonrpcx.org/api/authUserServer.php")!
        URLRequest.HTTPMethod = "POST"
        URLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonrpc.buildRequestJSON(), options: [])
        
        Alamofire.request(URLRequest)
            .responseJSON { response in
                if let json = response.result.value {
                    try! jsonrpc.parseResponseJSON(json)
                }
        }
    }

    @IBAction func didPush(sender: AnyObject) {
        guard let minuend = Int(self.firstTextField.text!), subtrahend = Int(self.secondTextField.text!) else {
            self.answerLabel.text = "?"
            return
        }
        
        self.subtract(minuend, subtrahend)
    }
}

