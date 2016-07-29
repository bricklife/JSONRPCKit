//
//  UIViewController+Error.swift
//  Example
//
//  Created by ishkawa on 2016/07/29.
//  Copyright © 2016年 Shinichiro Oba. All rights reserved.
//

import UIKit
import APIKit
import JSONRPCKit

extension UIViewController {

    func showAlertWithError(error: SessionTaskError) {
        let title: String?
        let message: String?

        switch error {
        case .ConnectionError(let error as NSError):
            title = error.localizedDescription
            message = error.localizedRecoverySuggestion

        case .ResponseError(let error as JSONRPCError):
            if case .MissingBothResultAndError(let object) = error {
                let data = try! NSJSONSerialization.dataWithJSONObject(object, options: .PrettyPrinted)
                let string = String(data: data, encoding: NSUTF8StringEncoding)!
                print(string)
            }

            if case .ResponseError(_, let errorMessage, let data as String) = error {
                title = errorMessage
                message = data
            } else {
                fallthrough
            }

        default:
            title = "Unknown error"
            message = nil
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

}
