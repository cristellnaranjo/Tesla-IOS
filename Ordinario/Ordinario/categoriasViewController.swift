//
//  categoriasViewController.swift
//  Ordinario
//
//  Created by Nailea Cruz on 29/05/22.
//

import UIKit

class categoriasViewController: UIViewController {
    
    var categorias = [Categoria]()
    var iduser = ""
    @IBOutlet weak var pedidosbtn: UIButton!
    @IBOutlet weak var categoriasTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        parseData()
        //print(categorias)
        categoriasTable.delegate = self
        categoriasTable.dataSource = self
    }
    
    @IBAction func pedidos(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "pedidosViewController") as! pedidosViewController
        myVC.iduser = iduser
        navigationController?.pushViewController(myVC, animated: true)
    }
    func parseData(){
        let url =  "http://dburss.ddns.net:8000/categoria"
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
                    let categoriastemp = fetchedData.value(forKey: "data")  as! NSArray
                    //print(categoriastemp)
                    for element in categoriastemp{
                        let categoria = element as! [String:Any]
                        let nombre = categoria["categoria_nombre"]
                        let id = categoria["categoria_id"]
                        let imagen = categoria["categoria_imagen"]
                        self.categorias.append(Categoria(id: id as! Int, nombre: nombre as! String, imagen: imagen as! String))
                    }
                    self.categoriasTable.reloadData()
                }
                catch{
                    print("Error 2")
                }
            }
        }
        task.resume()
    }
}
extension categoriasViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "productosViewController") as! productosViewController
        myVC.stringPassed = String(categorias[indexPath.row].id)
        myVC.iduser = iduser
        navigationController?.pushViewController(myVC, animated: true)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorias.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriasTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! categoriasTableViewCell
        cell.nombre.text = categorias[indexPath.row].nombre
        if let url = URL(string: categorias[indexPath.row].imagen ){
            do{
                let data = try Data(contentsOf: url)
                cell.imagen.image = UIImage(data: data)
                cell.imagen.layer.cornerRadius = 10
            }
            catch{
                print("Error imagen")
            }
        }
        cell.categoriasView.layer.shadowColor = UIColor.black.cgColor
        cell.categoriasView.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.categoriasView.layer.shadowOpacity = 1
        cell.categoriasView.layer.cornerRadius = 10
        return cell
    }
}
