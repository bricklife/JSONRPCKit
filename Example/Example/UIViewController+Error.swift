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

    func showAlertWithError(_ error: SessionTaskError) {
        let title: String?
        let message: String?

        switch error {
        case .connectionError(let error as NSError):
            title = error.localizedDescription
            message = error.localizedRecoverySuggestion

        case .responseError(let error as JSONRPCError):
            if case .responseError(_, let errorMessage, let data as String) = error {
                title = errorMessage
                message = data
            } else {
                fallthrough
            }

        default:
            title = "Unknown error"
            message = nil
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

}
