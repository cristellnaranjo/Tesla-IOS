//
//  Pedido.swift
//  Ordinario
//
//  Created by Nailea Cruz on 01/06/22.
//

import Foundation
class Pedido {
    var id: Int
    var modelo: String
    var cantidad: Int
    var precio: Double
    var estatus: Int
    var categoria: String
    
    init(id:Int, modelo: String, cantidad: Int, precio: Double, estatus: Int, categoria: String){
        self.id = id
        self.modelo = modelo
        self.cantidad = cantidad
        self.precio = precio
        self.estatus = estatus
        self.categoria = categoria
    }
}
