//  ViewControllerMiHistoria.swift
//  ProyectoRecuerdos

import UIKit

class resultadosQuiz {
    
    var numeroAciertos : Int!
    var numeroPreguntas : Int!
    var fechaRealizacion : Date!
    var presicionQuiz: Double!
    var quizTerminado: Bool!
    
    init(numeroAciertos: Int, numeroPreguntas: Int, fechaRealizacion: Date, presicionQuiz: Double, quizTerminado: Bool) {

        self.numeroAciertos = numeroAciertos
        self.numeroPreguntas = numeroPreguntas
        self.fechaRealizacion = fechaRealizacion
        self.presicionQuiz = presicionQuiz
        self.quizTerminado = quizTerminado
    }
}

class ViewControllerMiHistoria: UIViewController {
    
    var datosUsuario : NSDictionary!
    var usuarioNombre : String!
    var quizzesRealizados = [resultadosQuiz]()
    
    var anterior : ViewController!      // Apuntador a pantalla Principal
    var indexPath : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuracion de Navigation Bar
        usuarioNombre = datosUsuario.value(forKey: "nombreUsuario") as! String
        self.navigationItem.title = usuarioNombre
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funciones PREPARE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        quizzesRealizados.removeAll()
        
        if segue.identifier == "Configuraciones" {
            let viewApplicacion = segue.destination as! ViewControllerTConfiguraciones
            viewApplicacion.datosUsuario = datosUsuario
            viewApplicacion.vistaRaiz = anterior
            viewApplicacion.index = indexPath
            
        } else if segue.identifier == "viewMomentos" {
            let viewMomentos = segue.destination as! TableViewControllerMomentos
            viewMomentos.idUsuario = datosUsuario.value(forKey: "idUsuario") as! String
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 48/255, green: 138/255, blue: 191/255, alpha: 1)
            
        } else if segue.identifier == "Personas" {
            let viewPersonas = segue.destination as! ViewControllerPersonas
            viewPersonas.idUsuario = datosUsuario.value(forKey: "idUsuario") as! String
        } else {
            let viewQuiz = segue.destination as! ViewControllerPrueba
            viewQuiz.anterior = self
            viewQuiz.idUsuario = datosUsuario.value(forKey: "idUsuario") as! String
        }
    }
    
    // MARK: - Funciones de bloqueo de Orientación
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
}
