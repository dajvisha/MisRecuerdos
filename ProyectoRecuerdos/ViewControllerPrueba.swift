//  ViewControllerPrueba.swift
//  ProyectoRecuerdos

import UIKit
import GameplayKit

class ViewControllerPrueba: UIViewController {
    
    @IBOutlet weak var lbCantidadPreguntas: UILabel!
    @IBOutlet weak var tfcantidadPreguntas: UITextField!
    @IBOutlet weak var btComenzar: UIButton!
    
    var idUsuario : String!
    var anterior : ViewControllerMiHistoria!
    var cantidadPreguntas = 4
    var totalMomentos = 0
    var totalFamiliares = 0
    var totalConocidos = 0
    var totalArtistas = 0
    var totalPersonas : Int!
    
    // Listas y arreglos
    var listaMomentos : NSMutableArray!
    var listaFamiliares : NSMutableArray!
    var listaConocidos : NSMutableArray!
    var listaArtistas : NSMutableArray!
    var listaPreguntas = [Pregunta]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Ponte a prueba"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        btComenzar.bordesRedondos(radio: Double(btComenzar.frame.size.height))
        tfcantidadPreguntas.text = "\(cantidadPreguntas)"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewControllerAgregarUsuario.quitaTeclado))
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Funcion que obtiene la ruta de escritura de datos
    func dataFilePath(archivo : String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] + "/" + archivo + "-" + idUsuario + ".plist"
        return documentDirectory
    }
    
    // Funcion que verifica que toda la informacion necesaria exista al momento de presionar Comenzar
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        // Vaciar preguntas
        listaPreguntas.removeAll()
        
        // Verificar que hay preguntas suficientes
        // MOMENTOS
        // Obtener ruta de archivo
        var filePath = dataFilePath(archivo: "momentos")
        // Inicializacion de datos de arreglo
        if FileManager.default.fileExists(atPath: filePath) {
            listaMomentos = NSMutableArray(contentsOfFile: filePath)
        } else {
            // Inicializacion vacia (Cuando no existe informacion previa)
            listaMomentos = NSMutableArray()
        }
        totalMomentos = listaMomentos.count
        
        // FAMILIARES
        // Obtener ruta de archivo
        filePath = dataFilePath(archivo: "familiares")
        // Inicializacion de datos de arreglo
        if FileManager.default.fileExists(atPath: filePath) {
            listaFamiliares = NSMutableArray(contentsOfFile: filePath)
        } else {
            // Inicializacion vacia (Cuando no existe informacion previa)
            listaFamiliares = NSMutableArray()
        }
        totalFamiliares = listaFamiliares.count
        
        // CONOCIDOS
        // Obtener ruta de archivo
        filePath = dataFilePath(archivo: "conocidos")
        // Inicializacion de datos de arreglo
        if FileManager.default.fileExists(atPath: filePath) {
            listaConocidos = NSMutableArray(contentsOfFile: filePath)
        } else {
            // Inicializacion vacia (Cuando no existe informacion previa)
            listaConocidos = NSMutableArray()
        }
        totalConocidos = listaConocidos.count
        
        // ARTISTAS
        // Obtener ruta de archivo
        filePath = dataFilePath(archivo: "artistas")
        // Inicializacion de datos de arreglo
        if FileManager.default.fileExists(atPath: filePath) {
            listaArtistas = NSMutableArray(contentsOfFile: filePath)
        } else {
            // Inicializacion vacia (Cuando no existe informacion previa)
            listaArtistas = NSMutableArray()
        }
        totalArtistas = listaArtistas.count
        totalPersonas = totalFamiliares + totalConocidos + totalConocidos
        
        cantidadPreguntas = Int(tfcantidadPreguntas.text!)!
        
        if totalMomentos >= 4 && totalPersonas >= 4  && (totalPersonas + totalMomentos) >= cantidadPreguntas && cantidadPreguntas > 0 {
            // Llenar lista con preguntas
            obtenerPreguntas()
            return true
            
        } else {
            // Notificar a usuario que falta informacion para hacer quizzes
            var tipoAlerta = ""
            if (totalPersonas + totalMomentos) < cantidadPreguntas {
                tipoAlerta = "Necesitas guardar \(cantidadPreguntas - totalPersonas - totalMomentos) momento(s) y persona(s) más, con un minimo de 4 momentos y 4 personas"
            } else if totalMomentos < 4 {
                tipoAlerta = "Necesitas guardar \(4 - totalMomentos) momento(s) más"
            } else if totalPersonas < 4 {
                tipoAlerta = "Necesitas guardar \(4 - totalPersonas) persona(s) más"
            }
            
            let alerta = UIAlertController(title: "No hay informacion suficiente", message: tipoAlerta, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alerta, animated: true, completion: nil)
            return false
        }
    }
    
    // Funcion que obtiene las preguntas a mostrar en el quiz
    func obtenerPreguntas() {
        
        var nombreMomentos = [String]()
        var nombrePersonas = [String]()
        var nombre, apellido : String!
        
        // Obtener los nombres de todos los momentos y personas
        var n = 0
        while n < totalMomentos {
            let momentoDicc = listaMomentos[n] as! NSDictionary
            let nombreMomento = momentoDicc.value(forKey: "nombre") as! String
            nombreMomentos.append(nombreMomento)
            n += 1
        }

        n = 0
        while n < totalFamiliares {
            nombre = (listaFamiliares[n] as! NSDictionary).value(forKey: "nombre") as! String
            apellido = (listaFamiliares[n] as! NSDictionary).value(forKey: "apellidoPaterno") as! String
            nombrePersonas.append(nombre + " " + apellido)
            n += 1
        }
        n = 0
        while n < totalConocidos {
            nombre = (listaConocidos[n] as! NSDictionary).value(forKey: "nombre") as! String
            apellido = (listaConocidos[n] as! NSDictionary).value(forKey: "apellidoPaterno") as! String
            nombrePersonas.append(nombre + " " + apellido)
            n += 1
        }
        n = 0
        while n < totalArtistas {
            nombre = (listaArtistas[n] as! NSDictionary).value(forKey: "nombre") as! String
            apellido = (listaArtistas[n] as! NSDictionary).value(forKey: "apellidoPaterno") as! String
            nombrePersonas.append(nombre + " " + apellido)
            n += 1
        }
        
        var preguntaRandom : Int!	// Pregunta aleatoria
        var tipoPregunta : String!
        
        // Obtener las preguntas que pidio el usuario
        while cantidadPreguntas > 0
        {
            // Obtener pregunta de momento
            if totalMomentos > 0 {
                // Escoger una pregunta random
                tipoPregunta = "momento"
                preguntaRandom = Int(arc4random() % UInt32(totalMomentos))
                let elementoDicc = listaMomentos[preguntaRandom] as! NSDictionary
                listaMomentos.removeObject(at: preguntaRandom)	// Remover elemento de lista de momentos
                
                // Obtener respuestas de pregunta y guardar pregunta
                obtenerPreguntaRespuestas(elementoDicc: elementoDicc, arregloNombres: nombreMomentos, tipoPregunta: tipoPregunta)
                cantidadPreguntas -= 1		// Diminuir cantidad de preguntas faltantes
                totalMomentos -= 1
            }
            
            // Obtener pregunta de familiar
            if totalFamiliares > 0 && cantidadPreguntas > 0 {
                // Escoger una pregunta random
                tipoPregunta = "familiar"
                preguntaRandom = Int(arc4random() % UInt32(totalFamiliares))
                let elementoDicc = listaFamiliares[preguntaRandom] as! NSDictionary
                listaFamiliares.removeObject(at: preguntaRandom)	// Remover elemento de lista de familiares
                
                // Obtener respuestas de pregunta y guardar pregunta
                obtenerPreguntaRespuestas(elementoDicc: elementoDicc, arregloNombres: nombrePersonas, tipoPregunta: tipoPregunta)
                cantidadPreguntas -= 1		// Diminuir cantidad de preguntas faltantes
                totalFamiliares -= 1
            }
            // Obtener pregunta de conocido
            if totalConocidos > 0 && cantidadPreguntas > 0 {
                // Escoger una pregunta random
                tipoPregunta = "conocido"
                preguntaRandom = Int(arc4random() % UInt32(totalConocidos))
                let elementoDicc = listaConocidos[preguntaRandom] as! NSDictionary
                listaConocidos.removeObject(at: preguntaRandom)	// Remover elemento de lista de conocidos
                
                // Obtener respuestas de pregunta y guardar pregunta
                obtenerPreguntaRespuestas(elementoDicc: elementoDicc, arregloNombres: nombrePersonas, tipoPregunta: tipoPregunta)
                cantidadPreguntas -= 1		// Diminuir cantidad de preguntas faltantes
                totalConocidos -= 1
            }
            // Obtener pregunta de conocido
            if totalArtistas > 0 && cantidadPreguntas > 0 {
                // Escoger una pregunta random
                tipoPregunta = "conocido"
                preguntaRandom = Int(arc4random() % UInt32(totalArtistas))
                let elementoDicc = listaArtistas[preguntaRandom] as! NSDictionary
                listaArtistas.removeObject(at: preguntaRandom)	// Remover elemento de lista de conocidos
                // Obtener respuestas de pregunta y guardar pregunta
                obtenerPreguntaRespuestas(elementoDicc: elementoDicc, arregloNombres: nombrePersonas, tipoPregunta: tipoPregunta)
                cantidadPreguntas -= 1		// Diminuir cantidad de preguntas faltantes
                totalArtistas -= 1
            }
        }
    }
    
    // Funcion que crea una pregunta (con respuestas) y la guarda en la lista de preguntas
    func obtenerPreguntaRespuestas(elementoDicc: NSDictionary, arregloNombres: [String], tipoPregunta: String) {
        var arrNombres = arregloNombres
        var descPregunta = ""
        
        // Guardar respuesta correcta y fotografia
        var respuestaCorrecta : String!
        if tipoPregunta == "momento" {
            descPregunta = elementoDicc.value(forKey: "descripcion") as! String
            respuestaCorrecta = elementoDicc.value(forKey: "nombre") as! String
        } else {
            respuestaCorrecta = (elementoDicc.value(forKey: "nombre") as! String) + " " + (elementoDicc.value(forKey: "apellidoPaterno") as! String)
        }
        let foto = UIImage(data: elementoDicc.value(forKey: "foto") as! Data, scale:1.0)
        
        // Obtener respuestas de la pregunta
        var respuestas = ["","","",""]						// Arreglo de respuestas
        let lugarRespuesta = Int(arc4random() % 4)			// Escoger lugar para la respuesta correcta
        respuestas[lugarRespuesta] = respuestaCorrecta		// Guardar la respuesta en lugar escogido
        
        // Escoger respuestas falsas
        var lugarOtrasRespuestas = 0
        var eleccionRespuesta : Int!                        // Respuestas escogida aleatoriamente
        
        while lugarOtrasRespuestas < 4 {
            
            if lugarRespuesta != lugarOtrasRespuestas {
                // Elegir respuesta random
                eleccionRespuesta = Int(arc4random() % UInt32(arrNombres.count))
                
                // Si es respuesta repetida, eliminar
                if(arrNombres[eleccionRespuesta] == respuestaCorrecta) {
                    arrNombres.remove(at: eleccionRespuesta)
                }
                    // Si la respuesta es diferente a la respuesta correcta
                else {
                    // Guardar la respuesta falsa
                    respuestas[lugarOtrasRespuestas] = arrNombres[eleccionRespuesta]
                    arrNombres.remove(at: eleccionRespuesta)	// Eliminar respuesta para no repetir
                    lugarOtrasRespuestas += 1                   // Aumentar posicion de respuesta
                }
            } else {
                lugarOtrasRespuestas += 1
            }
        }
        
        // Agregar pregunta (con respuestas) a la lista de preguntas
        let preguntaX = Pregunta(descripcion: descPregunta, respuestas: respuestas, respuesta: lugarRespuesta, foto: foto!, tipoPregunta: tipoPregunta)
        listaPreguntas.append(preguntaX)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Quiz"{
            print("Total Preguntas :" + String(listaPreguntas.count))
            let vistaQuiz = segue.destination as! ViewControllerQuiz
            vistaQuiz.Preguntas = listaPreguntas
            vistaQuiz.anterior = anterior
        }
    }
    
    // Quita el teclado cuando se termina la edicion
    func quitaTeclado() {
        view.endEditing(true)
    }
    
    // MARK: - Funciones de bloqueo de Orientación
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
}
