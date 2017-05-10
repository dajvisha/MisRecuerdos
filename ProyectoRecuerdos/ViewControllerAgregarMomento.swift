//  ViewControllerAgregarMomento.swift
//  ProyectoRecuerdos

import UIKit
import MediaPlayer
import AVFoundation

class ViewControllerAgregarMomento: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,MPMediaPickerControllerDelegate, AVAudioPlayerDelegate {
    
    // Declaracion de elementos de interfaz
    @IBOutlet weak var imgImagen: UIImageView!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfDescripcion: UITextView!
    @IBOutlet weak var tfFecha: UITextField!
    @IBOutlet weak var btGuardar: UIButton!
    @IBOutlet weak var btMusica: UIButton!
    @IBOutlet weak var viewVista: UIView!
    @IBOutlet weak var vistaConstrintHeight: NSLayoutConstraint!
    @IBOutlet weak var btFotografia: UIButton!
    @IBOutlet weak var btEliminarFoto: UIButton!
    @IBOutlet weak var btEliminar: UIButton!
    
    // Declaracion de interfaz para musica
    @IBOutlet weak var fondoBotonMusica: UIView!
    @IBOutlet weak var btnEliminarMusica: UIButton!
    @IBOutlet weak var btnCambiarMusica: UIButton!
    @IBOutlet weak var lbCancion: UILabel!
    @IBOutlet weak var lbArtista: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
    // Declaracion de los botones que se mueven al agregar imagen
    var botonFotografia : CGRect? = nil
    var botonFotografiaX : CGFloat? = nil
    var botonFotografiaY : CGFloat? = nil
    
    var viewMusica : CGRect? = nil
    var viewMusicaX : CGFloat? = nil
    var viewMusicaY : CGFloat? = nil
    
    var botonMusica : CGRect? = nil
    var botonMusicaX : CGFloat? = nil
    var botonMusicaY : CGFloat? = nil
    
    var botonGuardar : CGRect? = nil
    var botonGuardarX : CGFloat? = nil
    var botonGuardarY : CGFloat? = nil
    
    var botonElim : CGRect? = nil
    var botonElimX : CGFloat? = nil
    var botonElimY : CGFloat? = nil
    
    var vistaContenedora : CGRect? = nil
    
    // Declaracion de elementos para Image Picker
    let imagePicker = UIImagePickerController()
    var fotoSeleccionada : UIImage!
    var seleccionoImagen = false
    var seleccionoVeces = 0
    
    // Declaracion de elemenots para Date Picker
    let datePicker = UIDatePicker()
    
    // Declaracion de variables
    var nombrePantalla = "Agregar Momento"          // Nombre de la pantalla
    var anterior : TableViewControllerMomentos!     // Apuntador a Tabla de momentos
    var momentoDicc : NSDictionary!                 // Infomacion del Momento
    var indexPath : IndexPath!                      // IndexPath del momento a modificar
    var momentoNSD : NSDictionary!                  // Momento creado aqui
    
    // Declaracion de elementos para mover TF cuando aparece teclado
    @IBOutlet weak var scrollView: UIScrollView!
    var alturaScrollView = 0
    var alturaTeclado : CGFloat!
    
    // Declaracion de elementos para musica
    var mediaPicker: MPMediaPickerController?
    var myMusicPlayer: MPMusicPlayerController?
    var songURL: URL! = nil
    var audioPlayer: AVAudioPlayer!
    var reproduciendo = false
    var cambiarMusica = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuracion del titulo en la Nav Bar
        title = nombrePantalla
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.isTranslucent = true
        btEliminar.isHidden = true
        btEliminar.bordesRedondos(radio: Double(btEliminar.frame.size.height))
        btGuardar.bordesRedondos(radio: Double(btGuardar.frame.size.height))
        
        // Configuracion de los Pickers
        imagePicker.delegate = self
        createDatePicker()
        
        // Oculta botones
        btEliminarFoto.isHidden = true
        
        // Mostrar informacion del momento
        if momentoDicc != nil {
            
            seleccionoImagen = true
            btEliminar.isHidden = false
            tfNombre.text = (momentoDicc.value(forKey: "nombre") as! String)
            tfDescripcion.text = (momentoDicc.value(forKey: "descripcion") as! String)
            fotoSeleccionada = UIImage(data: momentoDicc.value(forKey: "foto") as! Data, scale:1.0)
            let fechaSeleccionada = momentoDicc.value(forKey: "fecha") as! Date
            let calendario = Calendar(identifier: .gregorian)
            let formateador = DateFormatter()
            formateador.dateFormat = "MMMM"
            let dia = calendario.component(.day, from: fechaSeleccionada)
            let mes = "\(formateador.string(from: fechaSeleccionada))"
            let año = calendario.component(.year, from: fechaSeleccionada)
            tfFecha.text = "\(dia) de \(mes) de \(año)"
            
            let urlCancion = momentoDicc.value(forKey: "musica") as! String
            let nombreCancionS = momentoDicc.value(forKey: "cancion") as? String
            let nombreArtistaS = momentoDicc.value(forKey: "artista") as? String
            
            if (urlCancion != "") {
                
                songURL = URL(string: urlCancion)
                lbCancion.text = nombreCancionS
                lbArtista.text = nombreArtistaS
                btMusica.isHidden = true
                
            }
            
            ajustaElementos()
        }
        
        // Configuracion de elementos para mover el TF cuando aparece teclado
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewControllerAgregarMomento.quitaTeclado))
        self.view.addGestureRecognizer(tap)
        self.registrarseParaNotificacionesDeTeclado()
        
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Ajusta los elementos de la interfaz cuando se selecciona una fotografia
    func ajustaElementos() {
        
        if seleccionoImagen {
            
            btFotografia.setTitle("Cambiar fotografía", for: .normal)
            btEliminarFoto.isHidden = false
            imgImagen.isHidden = false
            
            // Muestra la imagen
            let imagenView : CGRect = imgImagen.bounds
            let imagenViewX: CGFloat = imgImagen.frame.origin.x
            let imagenViewY: CGFloat = imgImagen.frame.origin.y
            imgImagen.frame = CGRect(x: imagenViewX, y: imagenViewY, width: imagenView.width, height: imagenView.width)
            imgImagen.image = fotoSeleccionada
            
            if seleccionoVeces < 1 {
                
                // Mueve los botones
                botonFotografia = btFotografia.bounds
                botonFotografiaX = btFotografia.frame.origin.x
                botonFotografiaY = btFotografia.frame.origin.y
                btFotografia.frame = CGRect(x: botonFotografiaX!, y: botonFotografiaY! + imagenView.width, width: (botonFotografia?.width)!, height: (botonFotografia?.height)!)
                
                viewMusica = fondoBotonMusica.bounds
                viewMusicaX = fondoBotonMusica.frame.origin.x
                viewMusicaY = fondoBotonMusica.frame.origin.y
                fondoBotonMusica.frame = CGRect(x: viewMusicaX!, y: viewMusicaY! + imagenView.width, width: (viewMusica?.width)!, height: (viewMusica?.height)!)
                
                botonGuardar = btGuardar.bounds
                botonGuardarX = btGuardar.frame.origin.x
                botonGuardarY = btGuardar.frame.origin.y
                btGuardar.frame = CGRect(x: botonGuardarX!, y: botonGuardarY! + imagenView.width, width: (botonGuardar?.width)!, height: (botonGuardar?.height)!)
                
                botonElim = btEliminar.bounds
                botonElimX = btEliminar.frame.origin.x
                botonElimY = btEliminar.frame.origin.y
                btEliminar.frame = CGRect(x: botonElimX!, y: botonElimY! + imagenView.width, width: (botonElim?.width)!, height: (botonElim?.height)!)
                
                // Cambia el tamano de la vista contenedora
                vistaContenedora = viewVista.bounds
                vistaConstrintHeight.constant = (vistaContenedora?.height)! + imagenView.width
            }
        }
        
    }
    
    // Ajusta los elementos de la interfaz cuando se selecciona una fotografia
    @IBAction func unwindImagen(unwindSegue : UIStoryboardSegue) {
        
        if seleccionoImagen {
            
            btEliminarFoto.isHidden = false
            imgImagen.isHidden = false
            btFotografia.setTitle("Cambiar fotografía", for: .normal)
            
            // Muestra la imagen
            let imagenView : CGRect = imgImagen.bounds
            let imagenViewX: CGFloat = imgImagen.frame.origin.x
            let imagenViewY: CGFloat = imgImagen.frame.origin.y
            imgImagen.frame = CGRect(x: imagenViewX, y: imagenViewY, width: imagenView.width, height: imagenView.width)
            imgImagen.image = fotoSeleccionada
            
            if seleccionoVeces < 1 {
                
                // Mueve los botones
                botonFotografia = btFotografia.bounds
                botonFotografiaX = btFotografia.frame.origin.x
                botonFotografiaY = btFotografia.frame.origin.y
                btFotografia.frame = CGRect(x: botonFotografiaX!, y: botonFotografiaY! + imagenView.width + 15, width: (botonFotografia?.width)!, height: (botonFotografia?.height)!)
                
                viewMusica = fondoBotonMusica.bounds
                viewMusicaX = fondoBotonMusica.frame.origin.x
                viewMusicaY = fondoBotonMusica.frame.origin.y
                fondoBotonMusica.frame = CGRect(x: viewMusicaX!, y: viewMusicaY! + imagenView.width + 15, width: (viewMusica?.width)!, height: (viewMusica?.height)!)
                
                botonGuardar = btGuardar.bounds
                botonGuardarX = btGuardar.frame.origin.x
                botonGuardarY = btGuardar.frame.origin.y
                btGuardar.frame = CGRect(x: botonGuardarX!, y: botonGuardarY! + imagenView.width, width: (botonGuardar?.width)!, height: (botonGuardar?.height)!)
                
                botonElim = btEliminar.bounds
                botonElimX = btEliminar.frame.origin.x
                botonElimY = btEliminar.frame.origin.y
                btEliminar.frame = CGRect(x: botonElimX!, y: botonElimY! + imagenView.width, width: (botonElim?.width)!, height: (botonElim?.height)!)
                
                // Cambia el tamano de la vista contenedora
                vistaContenedora = viewVista.bounds
                let altoVC = vistaContenedora!.height
                let anchoImagen = imagenView.width
                vistaConstrintHeight.constant = altoVC + anchoImagen
            }
        }
    }
    
    // Ajusta los elementos de la interfaz cunado se elimina la fotografia seleccionada
    @IBAction func eliminaFoto(_ sender: UIButton) {
        
        btFotografia.setTitle("Agregar fotografía", for: .normal)
        
        btEliminarFoto.isHidden = true
        imgImagen.isHidden = true
        imgImagen.image = nil
        seleccionoVeces = 0
        seleccionoImagen = false
        
        btFotografia.frame = CGRect(x: botonFotografiaX!, y: botonFotografiaY!, width: (botonFotografia?.width)!, height: (botonFotografia?.height)!)
        fondoBotonMusica.frame = CGRect(x: viewMusicaX!, y: viewMusicaY!, width: (viewMusica?.width)!, height: (viewMusica?.height)!)
        btGuardar.frame = CGRect(x: botonGuardarX!, y: botonGuardarY!, width: (botonGuardar?.width)!, height: (botonGuardar?.height)!)
        btEliminar.frame = CGRect(x: botonElimX!, y: botonElimY!, width: (botonElim?.width)!, height: (botonElim?.height)!)
        vistaConstrintHeight.constant = (vistaContenedora?.height)!
        
    }
    
    // Funcion que elimina un momento
    @IBAction func eliminarMomento(_ sender: UIButton) {
        let mensajeBorrarUsuario = "¿Estas seguro de que deseas eliminar este momento?"
        let alerta = UIAlertController(title: "Eliminar", message: mensajeBorrarUsuario, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.default, handler: {action in self.eliminaMomento()}))
        alerta.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        present(alerta, animated: true, completion: nil)
    }
    
    func eliminaMomento() {
        anterior.eliminaMomento(at: indexPath)
        anterior.guardaInformacion()
        var viewControllers = self.navigationController?.viewControllers
        viewControllers?.removeLast()
        viewControllers?.removeLast()
        self.navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    
    // MARK: - Funciones para agregar musica
    
    @IBAction func agregaMusica(_ sender: UIButton) {
        
        // Pausa la musica
        if let player = audioPlayer {
            
            if cambiarMusica {
                btnPlay.setImage(#imageLiteral(resourceName: "iconPlay"), for: .normal)
                player.stop()
            }
            
        }
        
        cambiarMusica = true
        
        displayMediaPickerAndPlayItem()
        
    }
    
    func displayMediaPickerAndPlayItem() {
        
        let mediaPicker: MPMediaPickerController = MPMediaPickerController.self(mediaTypes:MPMediaType.music)
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = false
        self.present(mediaPicker, animated: true, completion: nil)
        
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true)
    }
    
    // Funcion del boton eliminar cancion
    @IBAction func eliminaMusica(_ sender: UIButton) {
        
        reproduciendo = false
        cambiarMusica = false
        
        // Pausa la musica
        if let player = audioPlayer {
            
            if reproduciendo {
                btnPlay.setImage(#imageLiteral(resourceName: "iconPause"), for: .normal)
                audioPlayer.play()
            } else {
                btnPlay.setImage(#imageLiteral(resourceName: "iconPlay"), for: .normal)
                player.stop()
            }
        }
        
        btMusica.isHidden = false
        btnEliminarMusica.isHidden = true
        btnCambiarMusica.isHidden = true
        
        lbCancion.text = "Canción"
        lbArtista.text = "Artista"
        songURL = nil
        btnPlay.setImage(#imageLiteral(resourceName: "iconPlay"), for: .normal)
        
    }
    
    // Abre el selector de musica
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        // Obtener información de la canción
        let representativeItem = mediaItemCollection.representativeItem
        
        if representativeItem?.assetURL != nil {
            
            let title = representativeItem?.title
            let artista = representativeItem?.artist
            
            // Obtiene el url de la cancion
            songURL = (representativeItem?.assetURL)!
            
            lbCancion.text = title
            lbArtista.text = artista
            btMusica.isHidden = true
            btnEliminarMusica.isHidden = false
            btnCambiarMusica.isHidden = false
            
            self.dismiss(animated: true)
            
        } else {
            
            // Si la cancion no se encuentra muestra alerta
            self.dismiss(animated: true)
            cancionNoDescargada()
            
        }
        
    }
    
    // Se llama cuando no se encuentra una cancion en el dispositivo
    func cancionNoDescargada() {
        
        let alerta = UIAlertController(title: "Error", message: "La canción seleccionada no esta descargada. Descargala.", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alerta, animated: true, completion: nil)
        
    }
    
    // Reproduce musica
    @IBAction func reproducirMusica(_ sender: UIButton) {
        
        if songURL != nil {
            
            audioPlayer = try? AVAudioPlayer(contentsOf: songURL!)
            // Detecta cuando termina de reproducirse una cancion
            audioPlayer.numberOfLoops = 0
            audioPlayer.delegate = self
            
            if audioPlayer != nil {
                audioPlayer.prepareToPlay()
            } else {
                print("Song not found")
            }
            
            reproduciendo = !reproduciendo
            
            if let player = audioPlayer {
                
                if reproduciendo {
                    btnPlay.setImage(#imageLiteral(resourceName: "iconPause"), for: .normal)
                    audioPlayer.play()
                } else {
                    btnPlay.setImage(#imageLiteral(resourceName: "iconPlay"), for: .normal)
                    player.stop()
                }
            }
        }
    }
    
    // Se llama cuando termina una cancion
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        reproduciendo = !reproduciendo
        
        if let player = audioPlayer {
            btnPlay.setImage(#imageLiteral(resourceName: "iconPlay"), for: .normal)
            player.stop()
        }
    }
    
    // Cuando se modifica el elemento que esta en reproduccion
    func nowPlayingItemIsChanged(notification: NSNotification){
        
        let key = "MPMusicPlayerControllerNowPlayingItemPersistentIDKey"
        
        let persistentID =
            notification.userInfo![key] as? NSString
        
        if let id = persistentID {
            print("Persistent ID = \(id)")
        }
        
    }
    
    // MARK: - Funciones para agregar o modificar momento
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if sender as! UIButton == btGuardar {
            
            let nombre = tfNombre.text!
            let descripcion = tfDescripcion.text!
            let fecha = datePicker.date as NSDate!
            let foto = imgImagen.image
            
            if nombre == "" || descripcion == "" || fecha == nil || foto == nil {
                let alerta = UIAlertController(title: "Error", message: "Los campos deben tener datos", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alerta, animated: true, completion: nil)
                return false
                
            } else {
                // Creacion de diccionario Momento
                let dataFoto = UIImageJPEGRepresentation(foto!, 0.5)
                
                var cancionURL = ""
                if songURL != nil {
                    cancionURL = songURL.absoluteString
                }
                
                momentoNSD = ["nombre" : nombre, "descripcion" : descripcion, "fecha" : fecha as Date!, "foto" : dataFoto!, "musica": cancionURL, "artista": lbArtista.text!, "cancion": lbCancion.text!]
                
                // Llamado a funcion que agrega o modifica
                if nombrePantalla == "Agregar Momento" {
                    anterior.agregarMomento(momentoDicc: momentoNSD)
                    navigationController!.popViewController(animated: true)
                    
                } else {
                    anterior.modificarMomento(momentoDicc: momentoNSD, at: indexPath)
                }
                anterior.guardaInformacion()
            }
        }
        
        return true
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender as! UIButton == btGuardar && nombrePantalla == "Modificar Momento" {
            let vista = segue.destination as! VCDetallesMomento
            vista.momentoDicc = momentoNSD
            vista.viewDidLoad()
        }
            
        else if segue.identifier == "viewAgregarMomento" {
            
            let vistaSeleccionarImagen2 = segue.destination as! ViewControllerSeleccionarFoto
            vistaSeleccionarImagen2.vistaAnterior = "viewAgregarMomento"
            vistaSeleccionarImagen2.seleccionoImagenVecesN = seleccionoVeces
            
            if seleccionoImagen {
                vistaSeleccionarImagen2.preSeleccionoImagen = fotoSeleccionada
                vistaSeleccionarImagen2.seleccionoImagen = true
            }
        }
    }
    
    // MARK - Data Picker
    
    // Modifica la informacion del TF cuando se cambia la fecha en el DP
    func dateChanged(_ sender: UIDatePicker) {
        
        let fechaSeleccionada = datePicker.date
        let calendario = Calendar(identifier: .gregorian)
        let formateador = DateFormatter()
        formateador.dateFormat = "MMMM"
        
        let dia = calendario.component(.day, from: fechaSeleccionada)
        let mes = "\(formateador.string(from: fechaSeleccionada))"
        let año = calendario.component(.year, from: fechaSeleccionada)
        
        tfFecha.text = "\(dia) de \(mes) de \(año)"
        
    }
    
    // Crea el elemento que permite seleccionar una fecha
    func createDatePicker() {
        
        // Configuracion general del DP
        datePicker.datePickerMode = .date
        datePicker.locale = NSLocale(localeIdentifier: "es_MX") as Locale
        
        // Configuración de la barra del DP
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Configuracion del boton "Listo"
        let btListo = UIBarButtonItem(title: "Listo", style: .plain, target: self, action: #selector(donePressed))
        let espacioBarra = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([espacioBarra, btListo], animated: true)
        
        tfFecha.inputAccessoryView = toolbar
        tfFecha.inputView = datePicker
        
    }
    
    // Muestra la fecha con el formato deseado
    func donePressed() {
        
        let fechaSeleccionada = datePicker.date
        let calendario = Calendar(identifier: .gregorian)
        let formateador = DateFormatter()
        formateador.dateFormat = "MMMM"
        
        let dia = calendario.component(.day, from: fechaSeleccionada)
        let mes = "\(formateador.string(from: fechaSeleccionada))"
        let año = calendario.component(.year, from: fechaSeleccionada)
        
        tfFecha.text = "\(dia) de \(mes) de \(año)"
        
        self.view.endEditing(true)
        
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
        
    }
    
    // Se llama cuando el teclado se ocultara
    func keyboardWillBeHidden (_ aNotification : Notification){
    }
    
    // Funciones que se llaman cuando se selecciona un TV
    func textViewDidBeginEditing (_ textView : UITextView ) {
        scrollView.setContentOffset(CGPoint(x: 0.0, y: alturaTeclado / 2), animated: true)
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
