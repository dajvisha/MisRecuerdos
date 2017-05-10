//  ViewControllerPersonas.swift
//  ProyectoRecuerdos

import UIKit

class ViewControllerPersonas: UIViewController {

    // Declaracion de elementos de interfaz
    @IBOutlet weak var btFamiliares: UIButton!
    @IBOutlet weak var btConocidos: UIButton!
    @IBOutlet weak var btArtistas: UIButton!
    
    // Declaracion de informacion del usuario
    var idUsuario = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuracion de la Navigation Bar
        self.navigationItem.title = "Personas"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funcions de PREPARE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let viewPersonas = segue.destination as! TableViewControllerPPersonas
        viewPersonas.titulo = segue.identifier
        self.navigationController?.navigationBar.isTranslucent = false
        
        // Configuracion de Navigation Bar
        if segue.identifier == "Familiares" {
            viewPersonas.colorCeldas = UIColor(red: 253/255, green: 248/255, blue: 245/255, alpha: 1)
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 201/255, green: 82/255, blue: 22/255, alpha: 1)
            viewPersonas.colorBar = UIColor(red: 201/255, green: 82/255, blue: 22/255, alpha: 1)
            viewPersonas.title = "Familiares"
            
        } else if segue.identifier == "Conocidos" {
            viewPersonas.colorCeldas = UIColor(red: 239/255, green: 247/255, blue: 239/255, alpha: 1)
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 36/255, green: 149/255, blue: 39/255, alpha: 1)
            viewPersonas.title = "Conocidos"
            viewPersonas.colorBar = UIColor(red: 36/255, green: 149/255, blue: 39/255, alpha: 1)
            
        } else {
            viewPersonas.colorCeldas = UIColor(red: 252/255, green: 250/255, blue: 255/255, alpha: 1)
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 107/255, green: 81/255, blue: 141/255, alpha: 1)
            viewPersonas.title = "Artistas de Epoca"
            viewPersonas.colorBar = UIColor(red: 107/255, green: 81/255, blue: 141/255, alpha: 1)
        }
        viewPersonas.idUsuario = idUsuario
        
    }
    
    // MARK: - Funciones de bloqueo de Orientación
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
}
