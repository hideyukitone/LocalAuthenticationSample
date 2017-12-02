//
//  ViewController.swift
//  LocalAuthenticationSample
//
//  Created by 大國嗣元 on 2017/12/02.
//  Copyright © 2017年 hideyuki okuni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton! {
        didSet {
            switch LocalAuthenticationManager.biometryType {
            case .touchId:
                button.setTitle("TouchID認証", for: .normal)
            case .faceId:
                button.setTitle("FaceID認証", for: .normal)
            case .none:
                button.isHidden = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressButton(_ sender: Any) {
        LocalAuthenticationManager.evaluatePolicy { result in
            print(result)
        }
    }
}

