//  ViewControllerQuiz.swift
//  ProyectoRecuerdos

import UIKit

class ViewControllerQuiz: UIViewController {
    
    @IBOutlet var botones: [UIButton]!
    @IBOutlet weak var btSiguiente: UIButton!
    @IBOutlet weak var lbNumeroPregunta: UILabel!
    @IBOutlet weak var lbPreguntaImagen: UILabel!
    @IBOutlet weak var lbPregunta: UILabel!
    @IBOutlet weak var imgImagen: UIImageView!
    @IBOutlet weak var lbAviso: UILabel!
    
    var Preguntas : [Pregunta]! // Lista de preguntas
    var anterior : ViewControllerMiHistoria!
    var numPreguntas = Int()
    var idUsuario : Int!
    var numeroPregunta = 0
    var respuestaPregunta = Int()
    var puntosTotales = 0
    var primerIntento = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        colorBotones(color: "azul")         // Inicializar los botones de color azul
        self.navigationItem.title = "Quiz"  // Titulo de la pantalla
        escogerPregunta()                   // Muestra la primer pregunta
    }
    
    // Funcion que cambia al color default de los botones
    func colorBotones(color: String) {
        if color == "azul" {
            for i in 0..<botones.count {
                botones[i].backgroundColor = UIColor(red: 74/255, green: 215/255, blue: 255/255, alpha: 0.4)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func escogerPregunta() {
        
        // Si hay mas preguntas, mostrar pregunta
        if numeroPregunta < Preguntas.count {
            
            // Restablecer pantalla
            primerIntento = true
            btSiguiente.isHidden = true
            colorBotones(color: "azul")
            activarBotones(activar: true)
            
            lbNumeroPregunta.text = "PREGUNTA NO. " + String(numeroPregunta + 1)
            respuestaPregunta = Preguntas[numeroPregunta].respuesta
            
            // Pregunta de momento
            let tipoPregunta = Preguntas[numeroPregunta].tipoPregunta
            if tipoPregunta == "momento" {
                lbPreguntaImagen.text = "¿Qué momento fue este?"
                
            } else if tipoPregunta == "familiar" {
                lbPreguntaImagen.text = "¿Quién es está persona?"
                
            } else if tipoPregunta == "conocido" {
                lbPreguntaImagen.text = "¿Quién es está persona?"
                
            }  else if tipoPregunta == "artista" {
                lbPreguntaImagen.text = "¿Como se llamaba este artista?"
            }
            // Mostrar fotografia
            imgImagen.image = Preguntas[numeroPregunta].foto
            
            for i in 0..<botones.count {
                botones[i].setTitle(Preguntas[numeroPregunta].respuestas[i], for: .normal)
            }
            numeroPregunta += 1
        }
    }
    
    // Funcion de los botones de respuesta
    @IBAction func responderPregunta(_ sender: UIButton) {
        
        // Verificar si la respuesta oprimida es la correcta
        if sender.tag == respuestaPregunta {
            lbAviso.text = "Correcto"
            if primerIntento == true {
                // Sumar 1 punto si fue el primer intento
                puntosTotales += 1
            }
            // Mostrar boton para avanzar
            btSiguiente.isHidden = false        // Mostrar boton siguiente
            activarBotones(activar: false)      // Desactivar Botones
            // Cambiar color del boton a verde
            sender.backgroundColor = UIColor(red: 91/255, green: 171/255, blue: 94/255, alpha: 0.6)
        }
        else {
            primerIntento = false
            // Cambiar color del boton a rojo
            sender.backgroundColor = UIColor(red: 255/255, green: 100/255, blue: 100/255, alpha: 0.5)
            lbAviso.text = "Ese no es\nIntenta de nuevo"
        }
    }
    
    // Funcion que muestra la siguiente pregunta
    @IBAction func siguientePregunta(_ sender: UIButton) {
        
        lbAviso.text = ""
        btSiguiente.isHidden = true
        
        print("Numero Pregunta :" + String(numeroPregunta))
        if numeroPregunta >= Preguntas.count {
            // Guardar resultado de Quiz
            anterior.quizzesRealizados.append(resultadosQuiz(numeroAciertos: puntosTotales, numeroPreguntas: Preguntas.count, fechaRealizacion: Date(), presicionQuiz: Double(puntosTotales)/Double(Preguntas.count), quizTerminado: true))
            print("Resultados Guardados")
            // Pasar a pantalla de resultados
            performSegue(withIdentifier: "mostrarResultados", sender: self)
        }
        escogerPregunta()
    }
    
    // Funcion que reactiva todos los botones
    func activarBotones(activar: Bool) {
        for i in 0..<botones.count {
            botones[i].isEnabled = activar
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewResultados = segue.destination as! ViewControllerResultados
        viewResultados.anterior = anterior
    }
    
    // MARK: - Funciones de bloqueo de Orientación
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}
