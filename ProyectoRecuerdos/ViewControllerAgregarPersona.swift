//  ViewControllerAgregarPersona.swift
//  ProyectoRecuerdos

import UIKit

class ViewControllerAgregarPersona: UIViewController, UIPickerViewDelegate {
    
    // Declaracion de elementos de interfaz
    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var btAgregarFoto: UIButton!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfApellidoPaterno: UITextField!
    @IBOutlet weak var tfApellidoMaterno: UITextField!
    @IBOutlet weak var tfFechaNacimiento: UITextField!
    @IBOutlet weak var tfComodin: UITextField!
    @IBOutlet weak var tfDescripcion: UITextView!
    @IBOutlet weak var btGuardar: UIButton!
    @IBOutlet weak var btEliminar: UIButton!
    @IBOutlet weak var lbDescripcion: UILabel!
    
    // Declaracion de elementos para seleccionar fecha
    let dpFecha = UIDatePicker()
    let imagePicker = UIImagePickerController()
    var nombrePantalla = ""
    var comodin = ""
    var personaDicc : NSDictionary!
    var anterior : TableViewControllerPPersonas!
    var indexPath : IndexPath!
    var personaNSDicc : NSDictionary!
    
    // Declaracion de elementos para la imagen del familiar
    var fotoPersona : UIImage!
    var seleccionoImagen = false
    var tituloComodin = ""
    
    // Control del TF y Teclado
    @IBOutlet weak var scrollView: UIScrollView!
    var alturaScrollView = 0
    var alturaTeclado : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Conficuracion de Navigation Bar
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // Configuracion incial de pantalla
        self.navigationItem.title = "Mi Historia"
        title = nombrePantalla
        tfComodin.placeholder = comodin
        btEliminar.isHidden = true
        tfDescripcion.isHidden = true
        lbDescripcion.isHidden = true
        btGuardar.bordesRedondos(radio: Double(btGuardar.frame.size.height))
        btEliminar.bordesRedondos(radio: Double(btEliminar.frame.size.height))
        
        if comodin == "Conocido de" {
            tituloComodin = "conocidoDe"
            tfFechaNacimiento.isHidden = true
            tfDescripcion.isHidden = false
            lbDescripcion.isHidden = false
            
        } else if comodin == "Parentesco" {
            tituloComodin = "parentesco"
            
        } else {
            tituloComodin = "tipoArtista"
            tfFechaNacimiento.isHidden = true
            tfApellidoPaterno.placeholder = "Apellido Paterno (Opcional)"
            tfApellidoMaterno.placeholder = "Apellido Materno (Opcional)"
            tfDescripcion.isHidden = false
            lbDescripcion.isHidden = false
        }
        
        // Configuracion de los elementos de la interfaz
        imgFoto.image = #imageLiteral(resourceName: "imgUsuario")
        tfNombre.setPaddingLeft(4)
        tfApellidoPaterno.setPaddingLeft(4)
        tfApellidoMaterno.setPaddingLeft(4)
        tfFechaNacimiento.setPaddingLeft(4)
        tfComodin.setPaddingLeft(4)
        imgFoto.imageToCircle()
        btAgregarFoto.buttonToCircle()
        
        // Mostrar informacion a Modificar
        if personaDicc != nil {
            
            tfNombre.text = (personaDicc.value(forKey: "nombre") as! String)
            tfApellidoPaterno.text = (personaDicc.value(forKey: "apellidoPaterno") as! String)
            tfApellidoMaterno.text = (personaDicc.value(forKey: "apellidoMaterno") as! String)
            tfComodin.text = (personaDicc.value(forKey: tituloComodin) as! String)
            fotoPersona = UIImage(data: personaDicc.value(forKey: "foto") as! Data, scale:1.0)
            imgFoto.image = fotoPersona
            seleccionoImagen = true
            
            let fechaSeleccionada = dpFecha.date
            let calendario = Calendar(identifier: .gregorian)
            let formateador = DateFormatter()
            formateador.dateFormat = "MMMM"
            
            let dia = calendario.component(.day, from: fechaSeleccionada)
            let mes = "\(formateador.string(from: fechaSeleccionada))"
            let año = calendario.component(.year, from: fechaSeleccionada)
            
            tfFechaNacimiento.text = "\(dia) de \(mes) de \(año)"
            if tituloComodin != "parentesco" {
                tfDescripcion.text = (personaDicc.value(forKey: "descripcion") as! String)
            }
            btEliminar.isHidden = false
            
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewControllerAgregarUsuario.quitaTeclado))
        self.view.addGestureRecognizer(tap)
        self.registrarseParaNotificacionesDeTeclado()
        
        // Inicializacion del Date Picker
        crearDP()
        dpFecha.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Funcion que actualiza pantalla al escoger imagen
    @IBAction func unwindImagen(unwindSegue : UIStoryboardSegue) {
        if seleccionoImagen {
            imgFoto.image = fotoPersona
        }
    }
    
    // MARK - Funciones para agregar a una persona
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if sender as! UIButton == btGuardar {
            
            var nombre = tfNombre.text!
            var apellidoPaterno = tfApellidoPaterno.text!
            var apellidoMaterno = tfApellidoMaterno.text!
            var comodinInfo = tfComodin.text!
            let descripcion = tfDescripcion.text!
            
            let fechaNacimiento = dpFecha.date as NSDate!
            let foto = imgFoto.image
            
            nombre = nombre.trimmingCharacters(in: .whitespaces)
            apellidoPaterno = apellidoPaterno.trimmingCharacters(in: .whitespaces)
            apellidoMaterno = apellidoMaterno.trimmingCharacters(in: .whitespaces)
            comodinInfo = comodinInfo.trimmingCharacters(in: .whitespaces)
            
            // Verficación de campos
            var mensaje = ""
            
            if nombre == "" {
                mensaje += " Nombre"
            }
            
            if apellidoPaterno == "" && tituloComodin != "tipoArtista" {
                if mensaje != "" {
                    mensaje += ","
                }
                mensaje += " Apellido Paterno"
            }
            
            if fechaNacimiento == nil && tituloComodin == "parentesco" {
                if mensaje != "" {
                    mensaje += ","
                }
                mensaje += " Fecha de Nacimiento"
            }
            
            if comodinInfo == "" {
                if mensaje != "" {
                    mensaje += ","
                }
                mensaje += " " + comodin
            }
            
            if mensaje != "" {
                mensaje = "Te falta agregar la siguiente información: " + mensaje + "."
            }
            
            if !seleccionoImagen {
                mensaje = "Falta agregar una foto"
            }
            
            // Despliegue de mensaje de informacion faltante
            if mensaje != "" {
                
                let alerta = UIAlertController(title: "Información incompleta", message: mensaje, preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alerta, animated: true, completion: nil)
                return false
                
            } else {
                
                // Crear y guardar persona si la información está completa
                let dataFoto = UIImageJPEGRepresentation(foto!, 0.5)
                personaNSDicc = ["nombre" : nombre, "apellidoPaterno" : apellidoPaterno, "apellidoMaterno" : apellidoMaterno, "fechaNacimiento" : fechaNacimiento! as Date, "foto" : dataFoto!, tituloComodin : comodinInfo, "descripcion" : descripcion]
                
                // Llamado a funcion que agrega o modifica
                if personaDicc == nil {
                    anterior.agregaPersona(personaDicc: personaNSDicc)
                    navigationController!.popViewController(animated: true)
                } else {
                    anterior.modificaPersona(personaDicc: personaNSDicc, at: indexPath)
                }
                anterior.guardaInformacion()
            }
        }
        
        return true
    }
    
    // Funcion del boton que llama a eliminar persona
    @IBAction func eliminarPersona(_ sender: Any) {
        let mensajeBorrarUsuario = "¿Estas seguro de que deseas eliminar a esta persona?"
        let alerta = UIAlertController(title: "Eliminar", message: mensajeBorrarUsuario, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default, handler: {action in self.eliminaPersona()}))
        alerta.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        present(alerta, animated: true, completion: nil)
    }
    
    func eliminaPersona() {
        anterior.eliminaPersona(at: indexPath)
        anterior.guardaInformacion()
        var viewControllers = self.navigationController?.viewControllers
        viewControllers?.removeLast()
        viewControllers?.removeLast()
        self.navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    
    // Funcion que regresa a pantalla anterior
    @IBAction func cancelarRegistro(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    // MARK: - Funciones PREPARE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender as! UIButton == btGuardar && indexPath != nil {
            
            let vista = segue.destination as! ViewControllerDetallesPersona
            vista.personaDicc = personaNSDicc
            vista.viewDidLoad()
        }
            
            // Envia datos a la vista Selecionar Imagen
        else if segue.identifier == "viewImagenPersona" {
            
            let vistaSeleccionarFoto = segue.destination as! ViewControllerSeleccionarFoto
            vistaSeleccionarFoto.vistaAnterior = "viewAgregarPersona"
            
            if seleccionoImagen {
                vistaSeleccionarFoto.preSeleccionoImagen = fotoPersona
                vistaSeleccionarFoto.seleccionoImagen = true
            }
        }
    }
    
    // MARK: - Funciones de DatePicker
    
    // Modifica la informacion del TF cuando se cambia la fecha en el DP
    func dateChanged(_ sender: UIDatePicker) {
        
        let fechaSeleccionada = dpFecha.date
        let calendario = Calendar(identifier: .gregorian)
        let formateador = DateFormatter()
        formateador.dateFormat = "MMMM"
        
        let dia = calendario.component(.day, from: fechaSeleccionada)
        let mes = "\(formateador.string(from: fechaSeleccionada))"
        let año = calendario.component(.year, from: fechaSeleccionada)
        
        tfFechaNacimiento.text = "\(dia) de \(mes) de \(año)"
        
    }
    
    // Crea el elemento que permite seleccionar una fecha.
    func crearDP() {
        
        // Configuracion general del DP
        dpFecha.datePickerMode = .date
        dpFecha.locale = NSLocale(localeIdentifier: "es_MX") as Locale
        
        // Configuración de la barra del DP
        let barraDP = UIToolbar()
        barraDP.sizeToFit()
        
        // Configuracion del boton "Listo"
        // Configuracion del boton "Listo"
        let btListo = UIBarButtonItem(title: "Listo", style: .plain, target: self, action: #selector(btListoPresionado))
        let espacioBarra = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        barraDP.setItems([espacioBarra, btListo], animated: true)
        
        // Configuracion de los elemenos del DP
        tfFechaNacimiento.inputAccessoryView = barraDP
        tfFechaNacimiento.inputView = dpFecha
        
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
        
        tfFechaNacimiento.text = "\(dia) de \(mes) de \(año)"
        
        self.view.endEditing(true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
        
        alturaTeclado = frame.height
        
        // Obtiene la altura scrollView
        alturaScrollView = Int(scrollView.frame.origin.y - scrollView.frame.size.height);
        
        // Actualiza la posicion del scrollView
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height + 10, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
    }
    
    // Se llama cuando el teclado se ocultara
    func keyboardWillBeHidden (_ aNotification : Notification){
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(alturaScrollView), right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    // Funciones que se llaman cuando se selecciona un TV
    func textViewDidBeginEditing (_ textView : UITextView ) {
        scrollView.setContentOffset(CGPoint(x: 0.0, y: alturaTeclado), animated: true)
    }
    
    func textViewDidEndEditing (_ textView : UITextView ) {
        scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
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
