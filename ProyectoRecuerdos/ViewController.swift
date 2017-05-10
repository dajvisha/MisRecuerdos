//  ViewController.swift
//  ProyectoRecuerdos

import UIKit

class ViewController: UIViewController {

    // Declaracion de elementos de interfaz
    @IBOutlet weak var lbTitulo: UILabel!
    @IBOutlet weak var imagenFoto: UIImageView!
    @IBOutlet weak var nombreUsuario: UILabel!
    @IBOutlet weak var btAgregarUsuario: UIButton!
    @IBOutlet weak var btAplicacion: UIButton!
    @IBOutlet weak var btMasUsuarios: UIButton!
    @IBOutlet weak var btMenosUsuarios: UIButton!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var btCreditos: UIButton!
    
    // Declaracion de elementos para almacenamiento permanente
    var listaUsuarios : NSMutableArray!
    
    // Declaracion de elementos para controlar la lista de usuarios
    var cantidadUsuarios = 0
    var indexUsuario = 0
    
    // Declaracion de elementos para registrar la informacion del usuario seleccionado
    var datosUsuario : NSDictionary!
    
    // Declaracion de elementos para cambiar la apariencia de Status Bar
    @IBInspectable var LightStatusBar: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Configuracion de la barra de navegacion
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // Carga los datos del usuario desde la plist
        indexUsuario = 0
        let filePath = dataFilePath()
        
        if FileManager.default.fileExists(atPath: filePath) {
            listaUsuarios = NSMutableArray(contentsOfFile: filePath)
            cantidadUsuarios = listaUsuarios.count
        } else {
            listaUsuarios = NSMutableArray()
        }
        
        // Configura la interfaz para mostrar la informacion de los usuarios
        if cantidadUsuarios > 0 {
            ocultaUsuario(valor: false)
            mostrarDatosUsuarios(index: indexUsuario)
        } else {
            ocultaUsuario(valor: true)
        }
        
        // Configura la interfaz para mostrar los botones de control de la lista de usuarios
        btMenosUsuarios.isHidden = true
        
        if cantidadUsuarios > 1 {
            btMasUsuarios.isHidden = false
        } else {
            btMasUsuarios.isHidden = true
        }
        
        // Convierte a ojetos circulares
        imagenFoto.imageToCircle()
        btAgregarUsuario.bordesRedondos(radio: Double(btAgregarUsuario.frame.size.height))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funciones de interactividad
    
    // Muestra/oculta cuentas de usuario
    func ocultaUsuario (valor: Bool) {
        nombreUsuario.isHidden = valor
        imagenFoto.isHidden = valor
        btAplicacion.isHidden = valor
    }
    
    // Muestra la informacion de cada usuario
    func mostrarDatosUsuarios(index : Int) {
        datosUsuario = listaUsuarios[index] as! NSDictionary
        let usuarioImagen = UIImage(data: datosUsuario.value(forKey: "imagenUsuario") as! Data, scale:1.0)!
        let usuarioNombre = datosUsuario.value(forKey: "nombreUsuario") as! String
        imagenFoto.image = usuarioImagen
        nombreUsuario.text = usuarioNombre
    }
    
    // Recorre la lista de usuarios a la derecha
    @IBAction func muestraMasUsuarios(_ sender: UIButton) {
        
        if (indexUsuario + 1) < cantidadUsuarios {
            indexUsuario += 1
            mostrarDatosUsuarios(index: indexUsuario)
        }
        
        // Actualiza las flechas
        editaFlechas()
    }
    
    // Recorre la lista de usuarios a la izquierda
    @IBAction func muestraMenosUsuarios(_ sender: UIButton) {
        
        if indexUsuario > 0 {
            indexUsuario -= 1
            mostrarDatosUsuarios(index: indexUsuario)
        }
        
        // Actualiza las flechas
        editaFlechas()
    }
    
    // MARK: - Funciones de configuracion de interfaz
    
    // Configura el despliegue de las flechas que permiten la navegacion en la lista de usuarios
    func editaFlechas() {
        
        if indexUsuario == (cantidadUsuarios - 1) {
            btMasUsuarios.isHidden = true
        } else {
            btMasUsuarios.isHidden = false
        }
        
        if indexUsuario != 0 {
            btMenosUsuarios.isHidden = false
        } else  {
            btMenosUsuarios.isHidden = true
        }
        
    }
    
    // Da transparencia a Navigation Bar
    func cambiarBarra() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "FFFFFF")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(hex: "FFFFFF")]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    
    // Cambia el color de Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Funciones PREPARE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        cambiarBarra()
        
        // Envia informacion a la vista Agregar Usuario
        if segue.identifier == "agregarUsuario" {
            let viewAgregarUsuario = segue.destination as! ViewControllerAgregarUsuario
            viewAgregarUsuario.vistaAnterior = self
        }
        
        // Envia informacion a la vista Principal de la App
        if segue.identifier == "entrarApp" {
            let viewApplicacion = segue.destination as! ViewControllerMiHistoria
            viewApplicacion.datosUsuario = datosUsuario
            viewApplicacion.indexPath = indexUsuario
            viewApplicacion.anterior = self
        }
        
    }
    
    // Recarga la lista de usuarios al retornar de la vista Agregar Usuario
    func cargarUsuarios() {
        viewDidLoad()
    }
    
    // MARK: - Funciones de permanencia de datos
    
    // Obtiene la ruta de escritura de datos
    func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] + "/usuarios.plist"
        return documentDirectory
    }
    
    // MARK: - Funciones Appear & Disappear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ocultar barra de navegacion
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Reaparecer la barra de navegacion
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Funciones de bloqueo de Orientación
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
}

