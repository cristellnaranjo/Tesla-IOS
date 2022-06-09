//
//  productoViewController.swift
//  Ordinario
//
//  Created by Nailea Cruz on 29/05/22.
//

import UIKit

class productoViewController: UIViewController {

    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var stepercant: UIStepper!
    @IBOutlet weak var cantidad: UILabel!
    @IBOutlet weak var finalizarbtn: UIButton!
    var nombreP = ""
    var descripcionP = ""
    var precioP = 0.0
    var imagenP = ""
    var idP = ""
    var iduser = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        nombre.text = nombreP
        descripcion.text = descripcionP
        precio.text = "$"+String(precioP)
        print(iduser)
        // Do any additional setup after loading the view.
        if let url = URL(string: imagenP ){
            do{
                let data = try Data(contentsOf: url)
                imagen.image = UIImage(data: data)
                imagen.layer.cornerRadius = 10
            }
            catch{
                print("Error imagen")
            }
        }
    }
    
    @IBAction func finalizar(_ sender: Any) {
        if(Int(stepercant.value) <= 0){
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width/2-75, y:self.view.frame.height - 100, width: 175, height: 40))
            toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10
            toastLabel.clipsToBounds = true
            toastLabel.text = "Agrega una cantidad"
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 1.0, options: .curveEaseInOut, animations: {
                toastLabel.alpha = 0.0
            }) {(isCompleted) in
                toastLabel.removeFromSuperview()
            }
            
        }else{
            let myVC = storyboard?.instantiateViewController(withIdentifier: "finalizarViewController") as! finalizarViewController
            myVC.cantidadP = String(Int(stepercant.value))
            myVC.modeloP = nombreP
            myVC.totalP = String(precioP * (Double(stepercant.value)))
            myVC.iduser = iduser
            myVC.idP = idP
            navigationController?.pushViewController(myVC, animated: true)
        }
        
    }
    @IBAction func cantidad(_ sender: Any) {
        cantidad.text = String(Int(stepercant.value))
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
