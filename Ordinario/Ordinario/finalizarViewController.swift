//
//  finalizarViewController.swift
//  Ordinario
//
//  Created by Nailea Cruz on 01/06/22.
//

import UIKit

class finalizarViewController: UIViewController {

    @IBOutlet weak var enviarp: UIButton!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var cancelarbtn: UIButton!
    @IBOutlet weak var menubtn: UIButton!
    @IBOutlet weak var descripcion: UILabel!
    var iduser = ""
    var cantidadP = ""
    var modeloP = ""
    var totalP = ""
    var idP = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        descripcion.text = cantidadP+" "+modeloP
        total.text = "$"+totalP
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    @IBAction func menu(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "categoriasViewController") as! categoriasViewController
        myVC.iduser = iduser
        navigationController?.pushViewController(myVC, animated: true)
    }
    @IBAction func enviaraction(_ sender: Any) {
        parseData()
    }
    @IBAction func cancelar(_ sender: Any) {
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    func parseData(){
        let url =  "http://dburss.ddns.net:8000/nuevopedido"
        var request = URLRequest(url: URL(string: url)!)
        print(iduser)
        request.httpMethod = "POST"
        let body: [String: AnyHashable] = [
            "iduser": iduser,
            "estatus": "1",
            "idproducto": idP,
            "cantidad": cantidadP
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil,delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { [self] (data, response, error) in
            if(error != nil){
                print("Error")
            }else {
                do{
                    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width/2-75, y:self.view.frame.height - 100, width: 150, height: 40))
                    toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.6)
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 10
                    toastLabel.clipsToBounds = true
                    toastLabel.text = "Pedido realizado"
                    self.view.addSubview(toastLabel)
                    UIView.animate(withDuration: 4.0, delay: 1.0, options: .curveEaseInOut, animations: {
                        toastLabel.alpha = 0.0
                    }) {(isCompleted) in
                        toastLabel.removeFromSuperview()
                    }
                
                    let myVC = storyboard?.instantiateViewController(withIdentifier: "categoriasViewController") as! categoriasViewController
                    myVC.iduser = iduser
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
