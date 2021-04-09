//
//  ViewController.swift
//  CameraFilter
//
//  Created by 전판근 on 2021/03/29.
//

import UIKit
import RxSwift
import SnapKit

class ViewController: UIViewController {
    
    let imageView = UIImageView()
    var applyFilterButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Apply Filter", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationInit()
        addView()
    }
    
    private func navigationInit() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Camera Filter"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(addTapped))
    }
    
    private func addView() {
        self.view.addSubview(imageView)
        self.view.addSubview(applyFilterButton)
        
        imageView.image = .add
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(100)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-100)
        }
        
        applyFilterButton.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalTo(self.view.center)
            make.width.equalTo(150)
            make.height.equalTo(36)
        }
        
        applyFilterButton.addTarget(self, action: #selector(apply), for: .touchUpInside)
        
    }

    @objc func addTapped() {
        print("TAP")
        
        let vc = NewViewController()
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true)
    }
    
    @objc func apply() {
        print("apply")
    }

}

