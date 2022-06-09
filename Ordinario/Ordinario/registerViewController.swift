//
//  registerViewController.swift
//  Ordinario
//
//  Created by Nailea Cruz on 29/05/22.
//

import UIKit

class registerViewController: UIViewController {

    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var correo: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func registerbtn(_ sender: Any) {
        parseData()
    }
    func parseData(){
        let url =  "http://dburss.ddns.net:8000/register"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let body: [String: AnyHashable] = [
            "nombre": "\(nombre.text ?? "")",
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
                
                    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width/2-20, y:self.view.frame.height - 100, width: 150, height: 40))
                    toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.6)
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 10
                    toastLabel.clipsToBounds = true
                    toastLabel.text = "Usuario registrado"
                    self.view.addSubview(toastLabel)
                    UIView.animate(withDuration: 4.0, delay: 1.0, options: .curveEaseInOut, animations: {
                        toastLabel.alpha = 0.0
                    }) {(isCompleted) in
                        toastLabel.removeFromSuperview()
                    }
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: . mutableLeaves) as! NSObject
                    let myVC = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
                    navigationController?.pushViewController(myVC, animated: true)
                    
                }
                catch{
                    print("Error 2")
                }
            }
        }
        task.resume()
    }
}
