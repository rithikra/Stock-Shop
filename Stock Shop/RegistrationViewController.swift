//
//  RegistrationViewController.swift
//  Stock Shop
//
//  Created by Rithik Rajani on 5/2/21.
//

import Foundation
import FirebaseAuth

import UIKit
//import FeedbackGenerator
class RegistrationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    @IBOutlet weak var signUpName: UITextField!
    
    @IBOutlet weak var signUpEmail: UITextField!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var signUpPassword: UITextField!
    @IBOutlet weak var signUpConfirmPassword: UITextField!
    
    @IBAction func tapRecognized(_ sender: Any) {
        loginEmail.resignFirstResponder()
        loginPassword.resignFirstResponder()
        signUpName.resignFirstResponder()
        signUpEmail.resignFirstResponder()
        signUpPassword.resignFirstResponder()
        signUpConfirmPassword.resignFirstResponder()
        print("TAP RECOGNIZED")
        self.becomeFirstResponder()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        self.becomeFirstResponder()
        //verify for correct info
        if ((loginEmail.text) != ""){
            let attemptedEmail = loginEmail.text! as String
            if ((loginPassword.text) != ""){
                let attemptedPassword = loginPassword.text! as String
                //attemppt the login here
                Auth.auth().signIn(withEmail: attemptedEmail, password: attemptedPassword){
                    user, error in
                    if (error != nil){
                        print("LOGIN DID NOT WORK")
                        self.errorMessageLabel.text = "Sign up did not work!"
                        self.errorMessageLabel.textColor = UIColor.red
                        
                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    }
                    else{
                        print("LOGIN WORKED!")
                        print(user!.user.uid)
                        
                        let currentUser = User(UID: user!.user.uid)
                        print("CURRENT USER : \(currentUser)")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let homeVC = storyboard.instantiateViewController(identifier: "mainTabBar")
                        self.self.view.window!.rootViewController = homeVC
                        
                        //self.performSegue(withIdentifier: "mainPage", sender: self)
                        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let homeVC = storyboard.instantiateViewController(identifier: "HomePage") as HomePageViewController
                        self.showDetailViewController(homeVC, sender: self)*/
                        //get all user info and allocate it to singleton here
                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    }
                    
                }
            }
            else{
                errorMessageLabel.text = "Please enter password"
                errorMessageLabel.textColor = UIColor.red
                let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
            }
        }
        else{
            errorMessageLabel.text = "Please enter email"
            errorMessageLabel.textColor = UIColor.red
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        }
        //let attemptedPassword = loginPassword.text as String
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if ((signUpEmail.text) != "" && ((signUpName.text) != "") && (signUpPassword.text != "" ) && (signUpConfirmPassword.text != "") ){
            let email = signUpEmail.text
            let password1 = signUpPassword.text
            let password2 = signUpConfirmPassword.text
            if (email?.contains("@") != true){
                errorMessageLabel.text = "Please enter correct email"
                errorMessageLabel.textColor = UIColor.red
                let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
            }
            else if (password1 != password2){
                errorMessageLabel.text = "Passwords do not match"
                errorMessageLabel.textColor = UIColor.red
                let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                impactFeedbackgenerator.prepare()
                impactFeedbackgenerator.impactOccurred()
                
            }
            else{
                Auth.auth().createUser(withEmail: email!, password: password1!) { authResult, error in
                    if (error != nil){
                        print("DID NOT WORK")
                        print(error as Any)
                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    }
                    else{
                        print("THIS WORKED")
                        let user = Auth.auth().currentUser
                        if let user = user {
                            //DispatchQueue.main.sync {
                                let currentUser = User(user.uid, self.signUpName.text!, email!)
                                print(currentUser)
                                print(User.sharedInstance)
                            //}
                            //print(currentUser)
                            
                            //var homeVC = HomePageViewControlle
                            //self.showDetailViewController(homeVC, sender: self)
                            //self.performSegue(withIdentifier: "testingSegue", sender: self)

                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let homeVC = storyboard.instantiateViewController(identifier: "mainTabBar")
                            self.self.view.window!.rootViewController = homeVC

                            //self.presentingViewController(homeVC, sender:self)
                            
                            
                            //set the current ID to user ID
                          // The user's ID, unique to the Firebase project.
                          // Do NOT use this value to authenticate with your backend server,
                          // if you have one. Use getTokenWithCompletion:completion: instead.
                          
                        }
                    }
                  // ...
                }
            }
        }
        else{
            errorMessageLabel.text = "Please enter all fields"
            errorMessageLabel.textColor = UIColor.red
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        }
        
        //check for all formatting issues
        //email has @in it
        //check that passwords match
    }
}
