//  ViewControllerDetallesPersona.swift
//  ProyectoRecuerdos

import UIKit

class ViewControllerDetallesPersona: UIViewController {
	
	// Parametros del segue
	var tituloModificar : String!
	var comodin = ""
	var anterior : TableViewControllerPPersonas!
    var indexPath : IndexPath!
	var personaDicc : NSDictionary!
    var colorLabel: UIColor!
	
	// Parametros de la interfaz
	@IBOutlet weak var lbNombre: UILabel!
	@IBOutlet weak var lbComodin1: UILabel!
	@IBOutlet weak var lbComodin: UILabel!
	@IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var lbFechaDeNacimiento: UILabel!
	@IBOutlet weak var lbFechaNacimiento: UILabel!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var tfDescripcion: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Detalles"
        tfDescripcion.isHidden = true
        
		// Mostrar datos segun el tipo de persona
		if comodin == "Conocido de" {
			lbComodin.text = (personaDicc.value(forKey: "conocidoDe") as! String)
            imgBackground.image = #imageLiteral(resourceName: "backgroundConocido")
            desplegarFecha(fecha: personaDicc.value(forKey: "fechaNacimiento") as! Date)
            lbFechaNacimiento.isHidden = true
            lbFechaDeNacimiento.isHidden = true
            tfDescripcion.isHidden = false
            tfDescripcion.text = (personaDicc.value(forKey: "descripcion") as! String)
            
		} else if comodin == "Parentesco" {
			lbComodin.text = (personaDicc.value(forKey: "parentesco") as! String)
            imgBackground.image = #imageLiteral(resourceName: "backgroundFamilia")
            desplegarFecha(fecha: personaDicc.value(forKey: "fechaNacimiento") as! Date)
            
		} else {
			lbComodin.text = (personaDicc.value(forKey: "tipoArtista") as! String)
            imgBackground.image = #imageLiteral(resourceName: "backgroundArtista")
            lbFechaNacimiento.isHidden = true
            lbFechaDeNacimiento.isHidden = true
            tfDescripcion.isHidden = false
            tfDescripcion.text = (personaDicc.value(forKey: "descripcion") as! String)
		}
        
        lbComodin1.text = comodin + ":"
        lbComodin.textColor = colorLabel
        lbFechaNacimiento.textColor = colorLabel
		
        // Mostar informacion de la persona
		lbNombre.text = (personaDicc.value(forKey: "nombre") as! String) + " " + (personaDicc.value(forKey: "apellidoPaterno") as! String) + " " + (personaDicc.value(forKey: "apellidoMaterno") as! String)
		imgFoto.image = UIImage(data: personaDicc.value(forKey: "foto") as! Data, scale:1.0)
        imgFoto.imageToCircle()
        
        // Configuracion de Navigation Bar
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Funcion que despliega la fecha en el formato correcto
    func desplegarFecha(fecha: Date) {
        let calendario = Calendar(identifier: .gregorian)
        let formateador = DateFormatter()
        formateador.dateFormat = "MMMM"
        
        let dia = calendario.component(.day, from: fecha)
        let mes = "\(formateador.string(from: fecha))"
        let año = calendario.component(.year, from: fecha)
        lbFechaNacimiento.text = "\(dia) de \(mes) de \(año)"
        lbFechaNacimiento.isHidden = false
    }
    
	@IBAction func unwindEnviar(unwindSegue : UIStoryboardSegue) {
		
	}
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		let viewModificar = segue.destination as! ViewControllerAgregarPersona
		viewModificar.nombrePantalla = tituloModificar
		viewModificar.personaDicc = personaDicc
        viewModificar.comodin = comodin
		viewModificar.anterior = anterior
        viewModificar.indexPath = indexPath
	}
    
    // MARK: - Funciones de bloqueo de Orientación
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
}
