//
//  LoginViewController.swift
//  Twitter
//
//  Created by Stephen Karukas on 11/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.bool(forKey: "isLoggedIn") == true) { login() }
    }
    
    func login() {
        self.performSegue(withIdentifier: "LoginToHome", sender: self)
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let loginUrl: String = "https://api.twitter.com/oauth/request_token";
        TwitterAPICaller.client?.login(url: loginUrl, success: {
            self.login()
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }, failure: { (Error) in
            print("Could not login")
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
