//
//  LoginViewController.swift
//  MusicListApp
//
//  Created by tomo on 2020/07/27.
//  Copyright © 2020 Tomo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import DTGradientButton

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    
   
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        //ボタンの背景色
        loginButton.setGradientBackgroundColors([UIColor(hex:"E21F70"),UIColor(hex:"FF4D2C")], direction: .toBottom, for: .normal)
        

        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
    
    @IBAction func login(_ sender: Any) {
        
//もしtextFieldの値が空でない場合、
        
        if textField.text?.isEmpty != true{
        
            
            //textFieldの値（ユーザー名）を自分のアプリ内に保存しておく
            
            UserDefaults.standard.set(textField.text, forKey: "userName")
            
            
        }else{
        
            //空ならば。振動させる
            let generator = UINotificationFeedbackGenerator();generator.notificationOccurred(.error)
            print("振動")
        }
        //FirebaseAuthの中にIDと名前を(TextField
        //.text)を入れる
        
        Auth.auth().signInAnonymously { (result,error) in
            
            if error == nil{
                
                guard let user = result?.user else{ return }
                
                let userID = user.uid
                UserDefaults.standard.set(userID, forKey: "userID")
                
                let saveProfile = SaveProfile(userID: userID, userName: self.textField.text!)
                saveProfile.saveProfile()
                
                self.dismiss(animated: true, completion: nil)
                                    
            
            }else{
           
                print(error?.localizedDescription as Any)
                
            
            
            
            
            
            }
            
            
        }
        
        
    
    
    
    
    
    
    
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
