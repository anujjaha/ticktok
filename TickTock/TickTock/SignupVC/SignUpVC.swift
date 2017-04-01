//
//  SignUpVC.swift
//  TickTock
//
//  Created by Yash on 25/03/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    @IBOutlet weak var txtUsername : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var txtEmailAddress : UITextField!
    @IBOutlet weak var txtConfirmPassword : UITextField!

    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    var image = UIImage()
    @IBOutlet weak var btnImageofUser : UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func backButtonPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSignUpPressed()
    {
        if (self.txtUsername.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else if (self.txtEmailAddress.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter email", inView: self)
        }
        else if (self.txtPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter password", inView: self)
        }
        else if (self.txtConfirmPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter confirm password", inView: self)
        }
        else if (self.txtPassword.text! != self.txtConfirmPassword.text!)
        {
            App_showAlert(withMessage: "Password and confirm password must be same", inView: self)
        }
        else
        {
            
            //       "url": "http://35.154.46.190:1337/api/user/register",
            /*request("\(kServerURL)login.php", method: .post, parameters:parameters).responseString{ response in
             debugPrint(response)
             }*/

            showProgress(inView: self.view)
            // define parameters
            let parameters = [
                "name": "\(self.txtUsername.text!)",
                "email": "\(self.txtEmailAddress.text!)",
                "password":"\(self.txtPassword.text!)"
            ]
            
            upload(multipartFormData:
                { (multipartFormData) in
                    
                    if let imageData2 = UIImageJPEGRepresentation(self.image, 1)
                    {
                        multipartFormData.append(imageData2, withName: "image", fileName: "myImage.jpg", mimeType: "file")
                    }
                    
                    for (key, value) in parameters
                    {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }, to: "\(kServerURL)user/register", method: .post, headers:["Content-Type": "application/x-www-form-urlencoded"], encodingCompletion:
                {
                    (result) in
                    switch result
                    {
                    case .success(let upload, _, _):
                        upload.responseJSON
                            {
                                response in
                                hideProgress()
                                
                                print(response.request) // original URL request
                                print(response.response) // URL response
                                print(response.result as Any) // result of response serialization
                                
                                if let json = response.result.value
                                {
                                    print("json :> \(json)")
                                    let dictemp = json as! NSDictionary
                                    print("dictemp :> \(dictemp)")
                                    if dictemp.count > 0
                                    {
                                        if  let dictemp2 = dictemp["data"] as? NSDictionary
                                        {
                                            if (dictemp2.count > 0)
                                            {
                                                print("dictemp :> \(dictemp2)")
                                                appDelegate.arrLoginData = dictemp2
                                                
                                                let data = NSKeyedArchiver.archivedData(withRootObject: appDelegate.arrLoginData)
                                                UserDefaults.standard.set(data, forKey: kkeyLoginData)
                                                UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
                                                
                                                let alertView = UIAlertController(title: Application_Name, message: "Signup Successfully", preferredStyle: .alert)
                                                let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                                                    let storyTab = UIStoryboard(name: "Main", bundle: nil)
                                                    let tabbar = storyTab.instantiateViewController(withIdentifier: "TabBarViewController")
                                                    self.navigationController?.pushViewController(tabbar, animated: true)
                                                }
                                                alertView.addAction(OKAction)
                                                self.present(alertView, animated: true, completion: nil)
                                            }
                                            else
                                            {
                                                App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                                            }
                                        }
                                        else
                                        {
                                            App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                                        }
                                    }
                                    else
                                    {
                                        App_showAlert(withMessage: dictemp[kkeymessage]! as! String, inView: self)
                                    }
                                }
                        }
                        
                    case .failure(let encodingError):
                        hideProgress()
                        print(encodingError)
                    }
            })
        }
    }
    
    //MARK: Select Image
    @IBAction func SelectImage()
    {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            App_showAlert(withMessage: "You don't have camera", inView: self)
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        image = resize(chosenImage)
        btnImageofUser.setImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("picker cancel.")
        dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
