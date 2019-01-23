//
//  FirstController.swift
//  github
//
//  Created by Dan on 1/20/19.
//  Copyright © 2019 Dan Viitenko. All rights reserved.
//

import UIKit

class FirstController: UIViewController {
    var username = ""
    @IBOutlet weak var usernameTextField: UITextField!
    var repo: UserRepo?
    
    @IBAction func findButton(_ sender: Any) {
        username = usernameTextField.text!
        if username == usernameTextField.text! {
        updateUser()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(keyboardDidHide))
        view.addGestureRecognizer(tap)
    }
    @objc func keyboardWillShow(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
        }
    }
    @objc func keyboardDidHide(){
        view.endEditing(true)
    }

    func updateUser(){
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.sync {
            let url = URL(string: "https://api.github.com/users/\(username)") as! URL
            let request = NSMutableURLRequest(url: url)
            URLSession.shared.dataTask(with: request as URLRequest){ (data, response, error) in
                if error != nil{
                    print(error!.localizedDescription)
                    return
                }
                do{
                    let json = try JSONDecoder().decode(UserRepo.self, from: data!)
                        DispatchQueue.main.async {
                            self.repo = json
                            self.performSegue(withIdentifier: "showSecondVC" , sender: self)
                          
                        }
                    
                }catch _{
                    self.presentErrorAlert()
                }
                }.resume()
        }
    }
    func presentErrorAlert(){
        let alert = UIAlertController(title: "Error", message: "Invalid name",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showSecondVC", let secondViewController = segue.destination as? SecondViewController {
                if repo != nil{
                secondViewController.user = repo
        }
    }
}
}
