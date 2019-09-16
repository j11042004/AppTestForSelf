//
//  IAPPurchaseDelegate.swift
//  IAPTest
//
//  Created by Uran on 2017/12/14.
//  Copyright © 2017年 Uran. All rights reserved.
//

import Foundation

protocol IAPPurchaseDelegate {
    func didBuySomething(_ viewcontroller:ProductsTableViewController, _ product: Product)
}
