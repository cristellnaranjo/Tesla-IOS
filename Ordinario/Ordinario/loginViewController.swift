//
//  loginViewController.swift
//  Ordinario
//
//  Created by Nailea Cruz on 29/05/22.
//

import UIKit

class loginViewController: UIViewController {

    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var loginbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

            // Do any additional setup after loading the view.
    }
    @IBAction func loginbtn(_ sender: Any) {
        parseData()
    }
    func parseData(){
        let url =  "http://dburss.ddns.net:8000/login"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let body: [String: AnyHashable] = [
            "correo": "\(correo.text ?? "")",
            "password": "\(pass.text ?? "")"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil,delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { [self] (data, response, error) in
            if(error != nil){
                print("Error")
            }else {
                do{
                
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: . mutableLeaves) as! NSObject
                    let resultado = fetchedData.value(forKey: "status_message")  as! NSString
                    if resultado == "Conectado"
                    {
                        let user = fetchedData.value(forKey: "data")  as! NSObject
                        print(String(describing: user.value(forKey: "usuario_id")  as! NSNumber))
                        let myVC = storyboard?.instantiateViewController(withIdentifier: "categoriasViewController") as! categoriasViewController
                        myVC.iduser = String(describing: user.value(forKey: "usuario_id")  as! NSNumber)
                        navigationController?.pushViewController(myVC, animated: true)
                        //print(user.value(forKey: "usuario_id")  as! NSNumber)
                    }else{
                        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width/2-75, y:self.view.frame.height - 100, width: 150, height: 40))
                        toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.6)
                        toastLabel.alpha = 1.0
                        toastLabel.layer.cornerRadius = 10
                        toastLabel.clipsToBounds = true
                        toastLabel.text = "Usuario incorrecto"
                        self.view.addSubview(toastLabel)
                        UIView.animate(withDuration: 4.0, delay: 1.0, options: .curveEaseInOut, animations: {
                            toastLabel.alpha = 0.0
                        }) {(isCompleted) in
                            toastLabel.removeFromSuperview()
                        }
                        
                    }
                    
                }
                catch{
                    print("Error 2")
                }
            }
        }
        task.resume()
    }
}
