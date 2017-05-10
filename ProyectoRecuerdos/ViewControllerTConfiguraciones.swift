//  ViewControllerTConfiguraciones.swift
//  ProyectoRecuerdos

import UIKit

class ViewControllerTConfiguraciones: UIViewController {

    // Declaracion de elementos de interfaz
    @IBOutlet weak var lbNombreUsuario: UILabel!
    @IBOutlet weak var lbSaludo: UILabel!
    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var btEditarPerfil: UIButton!
    @IBOutlet weak var btBorrarPerfil: UIButton!
    
    // Declaracion de informacion de usuario
    var listaUsuarios : NSMutableArray!
    var datosUsuario : NSDictionary!
    
    // Declaracion de la vista raiz
    var vistaRaiz : ViewController!
    var anterior : ViewControllerMiHistoria!
    var index : Int!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Configuracion de Navigation Bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        title = "Configuraciones"
        
        // Muestra el nombre del usuario
        let usuarioNombre = datosUsuario.value(forKey: "nombreUsuario") as! String
        lbNombreUsuario.text = usuarioNombre
        
        // Obtiene la lista de usuarios
        let filePath = dataFilePath(nombrePlist: "/usuarios.plist")
        
        if FileManager.default.fileExists(atPath: filePath) {
            listaUsuarios = NSMutableArray(contentsOfFile: filePath)
        } else {
            listaUsuarios = NSMutableArray()
        }
        
        // Configuracion de los elementos de la interfaz
        btEditarPerfil.bordesRedondos(radio: Double(btEditarPerfil.frame.size.height))
        btBorrarPerfil.bordesRedondos(radio: Double(btBorrarPerfil.frame.size.height))
        imgFoto.image = UIImage(data: datosUsuario.value(forKey: "imagenUsuario") as! Data, scale:1.0)
        imgFoto.imageToCircle()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Funcion que actualiza la informacion del usuario
    func cargarUsuario() {
        viewDidLoad()
    }
    
    // MARK: - Funciones para eliminar usuario
    
    // Funcion del boton elimiar perfil
    @IBAction func borrarUsuario(_ sender: UIButton) {
        
        let mensajeBorrarUsuario = "¿Estas seguro de que deseas borrar este usuario?"
        let alerta = UIAlertController(title: "Borrar", message: mensajeBorrarUsuario, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default, handler: {action in self.eliminarUsuario()}))
        alerta.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        present(alerta, animated: true, completion: nil)
        
    }
    
    // Funcion que elimina el perfil del usuario
    func eliminarUsuario() {
        
        let idUsuario = datosUsuario.value(forKey: "idUsuario") as! String
        let indexUsuario = index
        
        // Elimina al usuario del NSMutableArray
        listaUsuarios.removeObject(at: indexUsuario!)
        
        // Elimina el PLIST: Familiares
        let pathFamiliares = dataFilePath(nombrePlist: "/familiares-\(idUsuario).plist")
        
        do {
            if FileManager.default.fileExists(atPath: pathFamiliares) {
                try FileManager.default.removeItem(atPath: pathFamiliares)
            }
        } catch {
            print(error)
        }
        
        // Elimina el PLIST: Conocidos
        let pathConocidos = dataFilePath(nombrePlist: "/conocidos-\(idUsuario).plist")
        
        do {
            if FileManager.default.fileExists(atPath: pathConocidos) {
                try FileManager.default.removeItem(atPath: pathConocidos)
            }
        } catch {
            print(error)
        }
        
        // Elimina el PLIST: Artistas
        let pathArtistas = dataFilePath(nombrePlist: "/artistas-\(idUsuario).plist")
        
        do {
            if FileManager.default.fileExists(atPath: pathArtistas) {
                try FileManager.default.removeItem(atPath: pathArtistas)
            }
        } catch {
            print(error)
        }
        
        // Elimina el PLIST: Momentos
        let pathMomentos = dataFilePath(nombrePlist: "/momentos-\(idUsuario).plist")
        
        do {
            if FileManager.default.fileExists(atPath: pathMomentos) {
                try FileManager.default.removeItem(atPath: pathMomentos)
            }
        } catch {
            print(error)
        }
        
        // Retorna a la vista inicial
        vistaRaiz.viewDidLoad()
        navigationController!.popToRootViewController(animated: true)
        
    }
    
    // MARK: - Funciones de PREPARE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewModificar = segue.destination as! ViewControllerAgregarUsuario
        viewModificar.usuarioDicc = datosUsuario
        viewModificar.vistaAnterior = vistaRaiz
        viewModificar.nombrePantalla = "Modificar Usuario"
        viewModificar.index = index
    }
    
    // MARK: - Funciones para guardar informacion del usuario
    
    // Funcion que guarda infomacion cuando se presiona back
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController){
            guardaInformacion()
            vistaRaiz.cargarUsuarios()
        }
        
    }
    
    // Funcion que obtiene la ruta de escritura de datos
    func dataFilePath(nombrePlist: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] + nombrePlist
        return documentDirectory
    }
    
    // Funcion que guarda la infromacion del usuario
    func guardaInformacion() {
        print("Funciono:" + String(listaUsuarios.write(toFile: dataFilePath(nombrePlist: "/usuarios.plist"), atomically: true)))
    }
    
    // MARK: - Funciones de bloqueo de Orientación
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

}
