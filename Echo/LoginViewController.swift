//
//  ViewController.swift
//  Echo
//
//  Created by Christine Hong on 2/29/16.
//  Copyright © 2016 echo. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import ParseFacebookUtilsV4
import Parse

class LoginViewController: UIViewController {
//, FBSDKLoginButtonDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() == nil){
            print("user is not logged in")
        } else {
            openSetupPage()
        }
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        let permissions = ["public_profile", "email", "user_friends"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                print("HIII!")
                let echoUser = User(user: user)
                print("onlogin \(user)")
                if user.isNew {
                    self.openSetupPage()
                } else {
                    self.openHomePage()
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    func openSetupPage(){
        let authenticatedSetupViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AuthenticatedSetupViewController") as! AuthenticatedSetupViewController
        let authSetupPageNav = UINavigationController(rootViewController: authenticatedSetupViewController)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = authSetupPageNav
    }
    
    func openHomePage(){
        let homeViewController = self.storyboard!.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        let homePageNav = UINavigationController(rootViewController: homeViewController)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = homePageNav
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        print("user is logged out")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

