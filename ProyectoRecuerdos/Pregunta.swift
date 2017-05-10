//
//  Pregunta.swift
//  ProyectoRecuerdos
//
//  Created by Uriel Avila on 3/15/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class Pregunta: NSObject {
    
    var descripcion: String = ""
    var respuestas: [String] = []
    var respuesta: Int!
    var foto: UIImage!
    var tipoPregunta: String!
    
    init(descripcion: String, respuestas: [String], respuesta: Int, foto: UIImage, tipoPregunta: String) {
        self.descripcion = descripcion
        self.respuestas = respuestas
        self.respuesta = respuesta
        self.foto = foto
        self.tipoPregunta = tipoPregunta
    }
}
