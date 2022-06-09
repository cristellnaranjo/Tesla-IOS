//
//  Producto.swift
//  Ordinario
//
//  Created by Nailea Cruz on 28/05/22.
//

import Foundation
class Producto {
    var id: Int
    var nombre: String
    var imagen: String
    var descripcion: String
    var precio: Double
    
    init(id:Int, nombre: String, imagen: String, descripcion: String, precio: Double){
        self.id = id
        self.nombre = nombre
        self.imagen = imagen
        self.descripcion = descripcion
        self.precio = precio
    }
}

