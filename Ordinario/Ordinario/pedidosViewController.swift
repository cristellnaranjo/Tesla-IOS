//
//  pedidosViewController.swift
//  Ordinario
//
//  Created by Nailea Cruz on 01/06/22.
//

import UIKit

class pedidosViewController: UIViewController {
    var pedidos = [Pedido]()
    var iduser = ""
    @IBOutlet weak var pedidosTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        parseData()
        pedidosTable.delegate = self
        pedidosTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    func parseData(){
        let url =  "http://dburss.ddns.net:8000/pedido/user"+iduser
        print(url)
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
                    let pedidostemp = fetchedData.value(forKey: "data")  as! NSArray
                    print(pedidostemp)
                    for element in pedidostemp{
                        let pedido = element as! [String:Any]
                        let id = pedido["Pedido_id"]
                        let modelo = pedido["Modelo"]
                        let cantidad = pedido["Cantidad"]
                        let precio = pedido["Precio"]
                        let estatus = pedido["Estatus"]
                        let categoria = pedido["Categoria"]
                        self.pedidos.append(Pedido(id: id as! Int, modelo: modelo as! String, cantidad: cantidad as! Int, precio: precio as! Double, estatus: estatus as! Int, categoria: categoria as! String))
                    }
                    self.pedidosTable.reloadData()
                    print(pedidos)
                }
                catch{
                    print("Error 2")
                }
            }
        }
        task.resume()
    }
}
extension pedidosViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pedidos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pedidosTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! pedidosTableViewCell
        cell.producto.text = String(pedidos[indexPath.row].cantidad)+" "+pedidos[indexPath.row].modelo
        if(pedidos[indexPath.row].estatus == 1){
            cell.estatus.text = "En camino"
        }else{
            cell.estatus.text = "Entregado"
        }
        
        cell.precio.text = "$"+String(Double(pedidos[indexPath.row].cantidad) * pedidos[indexPath.row].precio)
        if(pedidos[indexPath.row].categoria == "Autos"){
            cell.imagen.image = UIImage(named: "auto")
        }
        if(pedidos[indexPath.row].categoria == "Camionetas"){
            cell.imagen.image = UIImage(named: "camioneta")
        }
        if(pedidos[indexPath.row].categoria == "Camiones"){
            cell.imagen.image = UIImage(named: "camion")
        }
        cell.imagen.layer.cornerRadius = 10
        cell.pedidosView.layer.shadowColor = UIColor.black.cgColor
        cell.pedidosView.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.pedidosView.layer.shadowOpacity = 1
        cell.pedidosView.layer.cornerRadius = 10
        
        return cell
    }
}

