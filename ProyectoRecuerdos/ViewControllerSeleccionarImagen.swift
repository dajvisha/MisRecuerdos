//  ViewControllerSeleccionarImagen.swift
//  ProyectoRecuerdos

import UIKit

class ViewControllerSeleccionarImagen: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // Declaracion de elementos de interfaz
    @IBOutlet weak var imagenUsuario: UIImageView!
    @IBOutlet weak var btListo: UIButton!
    
    // Declaracion de variables y constantes
    var seleccionoImagen = false
    var preSeleccionoImagen : UIImage!
    
    // Declaracion de elementos para seleccionar imagen
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Si el usuario ya habia seleccionado una imagen previamente y retorna a esta vista
        // muestra la imagen que fue preseleccionada
        if seleccionoImagen {
            imagenUsuario.image = preSeleccionoImagen
        }
        
        btListo.bordesRedondos(radio: Double(btListo.frame.size.height))
        
        // Configuracion de Navigation Bar
        title = "Elige una fotografía"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funciones control de fotografias
    
    // Cargar la imagen del usuario desde galeria
    @IBAction func cargarImagen(_ sender: UIButton) {
        
        let imagen = UIImagePickerController()
        imagen.delegate = self
        
        imagen.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagen.allowsEditing = false
        
        self.present(imagen, animated: true);
        
    }
    
    // Cargar la imagen del usuario desde la camara
    @IBAction func capturarImagen(_ sender: UIButton) {
        
        let imagen = UIImagePickerController()
        imagen.delegate = self
        
        imagen.sourceType = UIImagePickerControllerSourceType.camera
        imagen.allowsEditing = false
        
        self.present(imagen, animated: true);
        
    }
    
    // Mostrar la imagen seleccionada
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let imagen = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagenUsuario.image = imagen
            seleccionoImagen = true
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Funciones PREPARE
    
    // Metodo para enviar informacion
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Manda la imagen a la vista anterior
        if sender as! UIButton == btListo {
            let vistaAgregarUsuario = segue.destination as! ViewControllerAgregarUsuario
            if seleccionoImagen {
                vistaAgregarUsuario.fotoUsuario = imagenUsuario.image
                vistaAgregarUsuario.seleccionoImagen = true
            }
            else {
                vistaAgregarUsuario.seleccionoImagen = false
            }
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
