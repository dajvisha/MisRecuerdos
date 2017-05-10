//  ViewControllerResultados.swift
//  ProyectoRecuerdos

import UIKit

class ViewControllerResultados: UIViewController {

    @IBOutlet weak var btRegresar: UIButton!
    var anterior : ViewControllerMiHistoria!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
         btRegresar.bordesRedondos(radio: Double(btRegresar.frame.size.height))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Funcion que regresa a pantalla inicial de quizzes
    @IBAction func inicio(_ sender: Any) {
        var viewControllers = self.navigationController?.viewControllers
        viewControllers?.removeLast()
        viewControllers?.removeLast()
        self.navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    
    // MARK: - Funciones de bloqueo de Orientación
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}
