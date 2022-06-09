//
//  productosViewController.swift
//  Ordinario
//
//  Created by Nailea Cruz on 28/05/22.
//

import UIKit

class productosViewController: UIViewController{
    
    
    var producto = [Producto]()
    var stringPassed = ""
    var iduser = ""
    @IBOutlet weak var productosTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        productosTable.delegate = self
        productosTable.dataSource = self
        parseData()
        print("Productos"+iduser)
        // Do any additional setup after loading the view.
    }
    
    func parseData(){
        let url =  "http://dburss.ddns.net:8000/categoria/"+stringPassed
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil,delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { [self] (data, response, error) in
            if(error != nil){
                print("Error")
            }else {
                do{
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: . mutableLeaves) as! NSObject
                    let productostemp = fetchedData.value(forKey: "data")  as! NSArray
                    //print(productostemp)
                    for element in productostemp{
                        let producto = element as! [String:Any]
                        let nombre = producto["producto_nombre"]
                        let id = producto["producto_id"]
                        let imagen = producto["producto_imagen"]
                        let descripcion = producto["producto_descripcion"]
                        let precio = producto["producto_precio"]
                        self.producto.append(Producto(id: id as! Int, nombre: nombre as! String, imagen: imagen as! String, descripcion: descripcion as! String, precio: precio as! Double))
                    }
                    self.productosTable.reloadData()
                }
                catch{
                    print("Error 2")
                }
            }
        }
        task.resume()
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
extension productosViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "productoViewController") as! productoViewController
        myVC.idP = String(producto[indexPath.row].id)
        myVC.nombreP = String(producto[indexPath.row].nombre)
        myVC.descripcionP = String(producto[indexPath.row].descripcion)
        myVC.precioP = Double(producto[indexPath.row].precio)
        myVC.imagenP = String(producto[indexPath.row].imagen)
        myVC.iduser = iduser
        navigationController?.pushViewController(myVC, animated: true)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return producto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productosTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! productosTableViewCell
        cell.nombre.text = producto[indexPath.row].nombre
        if let url = URL(string: producto[indexPath.row].imagen ){
            do{
                let data = try Data(contentsOf: url)
                cell.imagen.image = UIImage(data: data)
                cell.imagen.layer.cornerRadius = 10
            }
            catch{
                print("Error imagen")
            }
        }
        cell.productosView.layer.shadowColor = UIColor.black.cgColor
        cell.productosView.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.productosView.layer.shadowOpacity = 1
        cell.productosView.layer.cornerRadius = 10
        return cell
    }
}
