//  ViewControllerAgregarUsuario.swift
//  ProyectoRecuerdos

import UIKit

class ViewControllerAgregarUsuario: UIViewController {

    // Declaracion de elementos de interfaz
    @IBOutlet weak var imagenAgregarFoto: UIImageView!
    @IBOutlet weak var btAgregarFoto: UIButton!
    @IBOutlet weak var tfNombreUsuario: UITextField!
    @IBOutlet weak var tfAPUsuario: UITextField!
    @IBOutlet weak var tfAMUsuario: UITextField!
    @IBOutlet weak var tfSeleccionarFecha: UITextField!
    @IBOutlet weak var btAgregar: UIButton!
    
    // Declaracion de elemenros de la vista anterior
    var vistaAnterior : ViewController!
    var index : Int!
    var nombrePantalla = "Agregar Usuario"
    var usuarioDicc : NSDictionary!
    
    // Declaracion de elementos para almacenamiento permanente
    var listaUsuarios : NSMutableArray!
    
    // Declaracion de elementos para seleccionar fecha
    let dpFecha = UIDatePicker()
    
    // Declaracion de elementos para la imagen de usuario
    var fotoUsuario : UIImage!
    var seleccionoImagen = false
    
    // Declaracion de elementos para mover el TF cuando aparece teclado
    @IBOutlet weak var scrollView: UIScrollView!
    var alturaScrollView = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuracion de la barra de navegacion
        title = "Agregar Usuario"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // Configuracion de los elementos de la interfaz
        imagenAgregarFoto.imageToCircle()
        btAgregarFoto.buttonToCircle()
        imagenAgregarFoto.image = #imageLiteral(resourceName: "imgUsuario")
        btAgregar.bordesRedondos(radio: Double(btAgregar.frame.size.height))
        
        // Configuracion del padding a la izquierda de los textfield
        tfNombreUsuario.setPaddingLeft(5)
        tfAPUsuario.setPaddingLeft(5)
        tfAMUsuario.setPaddingLeft(5)
        tfSeleccionarFecha.setPaddingLeft(5)
        
        // Obtencion de la ruta para la escritura permanente de datos
        let filePath = dataFilePath()
        
        // Inilizacion de datos del arreglo
        if FileManager.default.fileExists(atPath: filePath) {
            listaUsuarios = NSMutableArray(contentsOfFile: filePath)
        } else {
            listaUsuarios = NSMutableArray()
        }
        
        // Mustra datos si el usuario modificara su informacion
        if nombrePantalla == "Modificar Usuario" {
            
            tfNombreUsuario.text = (usuarioDicc.value(forKey: "nombreUsuario") as! String)
            tfAPUsuario.text = (usuarioDicc.value(forKey: "apUsuario") as! String)
            tfAMUsuario.text = (usuarioDicc.value(forKey: "amUsuario") as! String)
            fotoUsuario = UIImage(data: usuarioDicc.value(forKey: "imagenUsuario") as! Data, scale:1.0)
            imagenAgregarFoto.image = fotoUsuario
            
            let fechaSeleccionada = dpFecha.date
            let calendario = Calendar(identifier: .gregorian)
            let formateador = DateFormatter()
            formateador.dateFormat = "MMMM"
            
            let dia = calendario.component(.day, from: fechaSeleccionada)
            let mes = "\(formateador.string(from: fechaSeleccionada))"
            let año = calendario.component(.year, from: fechaSeleccionada)
            
            tfSeleccionarFecha.text = "\(dia) de \(mes) de \(año)"
            btAgregar.setTitle("Aceptar", for: .normal)
            
        }
        
        // Configuracion de elementos para mover el TF cuando aparece teclado
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewControllerAgregarUsuario.quitaTeclado))
        self.view.addGestureRecognizer(tap)
        self.registrarseParaNotificacionesDeTeclado()

        // Configuracion de elementos de DatePicker
        crearDP()
        dpFecha.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Funcion que cambia el color de la status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK - Date Picker
    
    // Se activa cuando el DP cambia
    func dateChanged(_ sender: UIDatePicker) {
    
        let fechaSeleccionada = dpFecha.date
        let calendario = Calendar(identifier: .gregorian)
        let formateador = DateFormatter()
        formateador.dateFormat = "MMMM"
        
        let dia = calendario.component(.day, from: fechaSeleccionada)
        let mes = "\(formateador.string(from: fechaSeleccionada))"
        let año = calendario.component(.year, from: fechaSeleccionada)
        
        tfSeleccionarFecha.text = "\(dia) de \(mes) de \(año)"
    }
    
    // Crea el elemento que permite seleccionar una fecha
    func crearDP() {
        
        // Configuracion general del DP
        dpFecha.datePickerMode = .date
        dpFecha.locale = NSLocale(localeIdentifier: "es_MX") as Locale
        
        // Configuración de la barra del DP
        let barraDP = UIToolbar()
        barraDP.sizeToFit()
        
        // Configuracion del boton "Listo"
        let btListo = UIBarButtonItem(title: "Listo", style: .plain, target: self, action: #selector(btListoPresionado))
        let espacioBarra = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        barraDP.setItems([espacioBarra, btListo], animated: true)
        
        // Configuracion de los elemenos del DP
        tfSeleccionarFecha.inputAccessoryView = barraDP
        tfSeleccionarFecha.inputView = dpFecha
    }
    
    // Muestra la fecha con el formato deseado
    func btListoPresionado() {
        
        let fechaSeleccionada = dpFecha.date
        let calendario = Calendar(identifier: .gregorian)
        let formateador = DateFormatter()
        formateador.dateFormat = "MMMM"
        
        let dia = calendario.component(.day, from: fechaSeleccionada)
        let mes = "\(formateador.string(from: fechaSeleccionada))"
        let año = calendario.component(.year, from: fechaSeleccionada)
        
        tfSeleccionarFecha.text = "\(dia) de \(mes) de \(año)"
        
        self.view.endEditing(true)
        
    }
    
    // MARK - Almacenamiento de la informacion
    
    // Guarda la informacion del usuario en la PL
    @IBAction func guardarUsuario(_ sender: UIButton) {
        
        var nombreUsuario = tfNombreUsuario.text!
        var apUsuario = tfAPUsuario.text!
        var amUsuario = tfAMUsuario.text!
        let fechaNacimiento = dpFecha.date as NSDate!
        var idUsuario = generaID()
        
        nombreUsuario = nombreUsuario.trimmingCharacters(in: .whitespaces)
        apUsuario = apUsuario.trimmingCharacters(in: .whitespaces)
        amUsuario = amUsuario.trimmingCharacters(in: .whitespaces)
        
        // Verificar datos completos
        let validaDatosCompletos = nombreUsuario != "" && apUsuario != "" && fechaNacimiento != nil && fotoUsuario != nil
        
        if validaDatosCompletos {
            
            // Registra la informacion del usuario
            let dataFoto = UIImageJPEGRepresentation(fotoUsuario, 0.5)
            
            if nombrePantalla == "Modificar Usuario" {
                idUsuario = usuarioDicc.value(forKey: "idUsuario") as! String
            }
            
            let diccUsuario : NSDictionary = [ "idUsuario" : idUsuario,
                                               "imagenUsuario" :  dataFoto!,
                                               "nombreUsuario" : nombreUsuario,
                                               "apUsuario" : apUsuario,
                                               "amUsuario" : amUsuario,
                                               "fechaNacimiento" : fechaNacimiento as Date!]
            
            // Modificacion de perfil de usuario
            if nombrePantalla == "Modificar Usuario" {
                vistaAnterior.listaUsuarios.replaceObject(at: index, with: diccUsuario)
                vistaAnterior.listaUsuarios.write(toFile: dataFilePath(), atomically: true)
                vistaAnterior.cargarUsuarios()
                vistaAnterior.indexUsuario = index
                vistaAnterior.mostrarDatosUsuarios(index: index)
                vistaAnterior.editaFlechas()
                navigationController!.popToRootViewController(animated: true)
            } else {
                // Guardado de nuevo perfil de usuario
                listaUsuarios.add(diccUsuario)
                listaUsuarios.write(toFile: dataFilePath(), atomically: true)
                vistaAnterior.cargarUsuarios()
                navigationController!.popViewController(animated: true)
            }
            
        } else {
            
            // Muestra alerta cuando la informacion esta incompleta o incorrecta
            let alerta = UIAlertController(title: "Error", message: "La información de los campos debe estar completa y correcta.", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alerta, animated: true, completion: nil)
        }
        
    }
    
    // Funcion que genera un ID para el usuario
    func generaID() -> String {
        
        var id = 0
        let tamanoLista = listaUsuarios.count
        
        if tamanoLista == 0 {
            id = 1
        } else  {
            
            let datosUsuarios = listaUsuarios[tamanoLista-1] as! NSDictionary
            let idUsuario = datosUsuarios.value(forKey: "idUsuario") as! String
            id = Int(idUsuario)! + 1
        }
        
        return String(id)
    }
    
    // Obtine la direccion del archivo donde se registraran los nuevos usuarios.
    func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] + "/usuarios.plist"
        
        return documentDirectory
    }
    
    // Se invoca cuando se desea cancelar el registro de un usuario.
    @IBAction func cancelarRegistroUsuario(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }

    // MARK - Navegacion
    
    // Se invoca cuando se retorna de la vista Seleccionar Imagen
    @IBAction func unwindImagenUsuario(unwindSegue : UIStoryboardSegue) {
        
        if seleccionoImagen {
            imagenAgregarFoto.image = fotoUsuario
        }
        
    }
    
    // Se invoca cuando se cambiara de vista
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Envia datos a la vista Selecionar Imagen
        if segue.identifier == "viewImagenUsuario" {
            
            let vistaSeleccionarImagen = segue.destination as! ViewControllerSeleccionarImagen
            
            if seleccionoImagen {
                vistaSeleccionarImagen.preSeleccionoImagen = fotoUsuario
                vistaSeleccionarImagen.seleccionoImagen = true
            }
        }
    }
    
    // MARK - Mover TF cuando aparece Teclado
    
    // Registrar notificaciones del teclado
    fileprivate func registrarseParaNotificacionesDeTeclado() {
        NotificationCenter.default.addObserver(self, selector:#selector(ViewControllerAgregarUsuario.keyboardWasShown(_:)),
                                               name:NSNotification.Name.UIKeyboardWillShow, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(ViewControllerAgregarUsuario.keyboardWillBeHidden(_:)),
                                               name:NSNotification.Name.UIKeyboardWillHide, object:nil)
    }
    
    // Se llama cuando el teclado se mostrara
    func keyboardWasShown (_ aNotification : Notification ) {
        
        // Obtiene la altura del teclado
        guard let userInfo = aNotification.userInfo, let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        // Obtiene la altura scrollView
        alturaScrollView = Int(scrollView.frame.origin.y - scrollView.frame.size.height);
        
        // Actualiza la posicion del scrollView
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
    }
    
    // Se llama cuando el teclado se ocultara
    func keyboardWillBeHidden (_ aNotification : Notification){
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(alturaScrollView), right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
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
