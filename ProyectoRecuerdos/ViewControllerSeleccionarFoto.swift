//  ViewControllerSeleccionarFoto.swift
//  ProyectoRecuerdos

import UIKit

class ViewControllerSeleccionarFoto: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // Declaracion de elementos de interfaz
    @IBOutlet weak var imgImagen: UIImageView!
    @IBOutlet weak var btnListo: UIButton!
    
    // Declaracion de variables y constantes
    var seleccionoImagen = false
    var preSeleccionoImagen : UIImage!
    var vistaAnterior : String!
    var seleccionoImagenVecesB = false
    var seleccionoImagenVecesN = 0
    
    // Declaracion de elementos para seleccionar imagen
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Si el usuario ya habia seleccionado una imagen previamente y retorna a esta vista
        // muestra la imagen que fue preseleccionada
        if seleccionoImagen {
            imgImagen.image = preSeleccionoImagen
            seleccionoImagenVecesB = true
        }
        
        btnListo.bordesRedondos(radio: Double(btnListo.frame.size.height))
        title = "Elige una fotografía"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Funciones control de fotografias
    
    // Metodo para cargar la imagen del usuario desde la galeria
    @IBAction func cargarImagen(_ sender: UIButton) {
        
        let imagen = UIImagePickerController()
        imagen.delegate = self
        
        imagen.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagen.allowsEditing = false
        
        self.present(imagen, animated: true) {
        }
        
    }
    
    // Metodo para cargar la imagen del usuario desde la camara
    @IBAction func capturarImagen(_ sender: UIButton) {
        
        let imagen = UIImagePickerController()
        imagen.delegate = self
        
        imagen.sourceType = UIImagePickerControllerSourceType.camera
        imagen.allowsEditing = false
        
        self.present(imagen, animated: true) {
        }
        
    }
    
    // Metodo para mostrar la imagen seleccionada
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let imagen = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgImagen.image = imagen
            seleccionoImagen = true
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Funciones PREPARE
    
    // Metodo para enviar informacion
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Manda la imagen a la vista anterior
        if sender as! UIButton == btnListo {
            
            if vistaAnterior == "viewAgregarMomento" {
                
                let vistaAgregarMomento = segue.destination as! ViewControllerAgregarMomento
                
                if seleccionoImagenVecesB {
                    vistaAgregarMomento.seleccionoVeces = seleccionoImagenVecesN + 1
                }
                
                if seleccionoImagen {
                    vistaAgregarMomento.fotoSeleccionada = imgImagen.image
                    vistaAgregarMomento.seleccionoImagen = true
                }
                else {
                    vistaAgregarMomento.seleccionoImagen = false
                }
                
            } else if vistaAnterior == "viewAgregarPersona" {
                
                let vistaAgregarPersona = segue.destination as! ViewControllerAgregarPersona
                
                if seleccionoImagen {
                    vistaAgregarPersona.fotoPersona = imgImagen.image
                    vistaAgregarPersona.seleccionoImagen = true
                } else {
                    vistaAgregarPersona.seleccionoImagen = false
                }
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
