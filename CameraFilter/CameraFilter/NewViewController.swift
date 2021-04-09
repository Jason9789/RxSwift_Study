//
//  NewViewController.swift
//  CameraFilter
//
//  Created by 전판근 on 2021/04/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NewViewController: UIViewController {
    let test = UILabel()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        
        print("New View Controller")
        
        self.view.addSubview(test)
        
        test.snp.makeConstraints { (make) in
            test.text = "NEW VIEW CONTROLLER"
            test.backgroundColor = .blue
            test.textColor = .white
            
            make.centerX.centerY.equalTo(self.view)
        }
    }
    
}
