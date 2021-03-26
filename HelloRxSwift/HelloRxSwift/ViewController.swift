//
//  ViewController.swift
//  HelloRxSwift
//
//  Created by 전판근 on 2021/03/26.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         
        _ = Observable.from([1, 2, 3, 4, 5])
    }


}

