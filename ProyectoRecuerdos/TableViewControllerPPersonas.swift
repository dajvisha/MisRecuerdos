//  TableViewControllerPPersonas.swift
//  ProyectoRecuerdos

import UIKit

class TableViewControllerPPersonas: UITableViewController {

    // Arreglo que guardara a las personas registradas
	var listaPersonas : NSMutableArray!
    
    // Configuracion de los elementos de la interfaz
    var titulo : String!
    var idUsuario = ""
    var colorCeldas = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    var colorBar : UIColor!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
        // Elimina la separacion entre las lineas
        self.tableView.separatorStyle = .none
        
		let filePath = dataFilePath() // Ruta de Archivos
		
		// Inicializacion de datos de arreglo
		if FileManager.default.fileExists(atPath: filePath) {
			listaPersonas = NSMutableArray(contentsOfFile: filePath)
		} else {
			listaPersonas = NSMutableArray()
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = colorBar
    }
    
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listaPersonas.count
	}
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TableViewCellPersonas {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath) as! TableViewCellPersonas
        
        // Formateador de Fecha
        let formateador = DateFormatter()
        
        // Obtener Persona del arreglo
        formateador.dateFormat = "MMMM d, y"
        let personaDicc = listaPersonas[indexPath.row] as! NSDictionary
        
        // Configura la informacion de la persona
        if titulo == "Conocidos" {
            cell.lbComodin1?.text = "Conocido de:"
            cell.lbComodin2?.text = (personaDicc.value(forKey: "conocidoDe") as! String)
            
        } else if titulo == "Familiares" {
            cell.lbComodin1?.text = "Parentesco:"
            cell.lbComodin2?.text = (personaDicc.value(forKey: "parentesco") as! String)
            
        } else if titulo == "Artistas" {
            cell.lbComodin1?.text = "Tipo de Artista:"
            cell.lbComodin2?.text = (personaDicc.value(forKey: "tipoArtista") as! String)
        }
        
        cell.lbComodin2.textColor = colorBar
        cell.backgroundColor = colorCeldas
        
        // Datos de la persona en la celda
        cell.imgFoto?.image = UIImage(data: personaDicc.value(forKey: "foto") as! Data, scale:1.0)
        cell.lbNombre?.text = (personaDicc.value(forKey: "nombre") as! String) + " " + (personaDicc.value(forKey: "apellidoPaterno") as! String)
        
        return cell
    }
	
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Vista revisar detalles de una persona
        if segue.identifier == "Detalles" {
            
            cambiarBarra()
            
            let viewDetalles = segue.destination as! ViewControllerDetallesPersona
            let indexPath = tableView.indexPathForSelectedRow
            let personaDicc = listaPersonas[indexPath!.row] as! NSDictionary
            
            if titulo == "Conocidos" {
                viewDetalles.tituloModificar = "Modificar Conocido"
                viewDetalles.comodin = "Conocido de"
            } else if titulo == "Familiares" {
            	viewDetalles.tituloModificar = "Modificar Familiar"
                viewDetalles.comodin = "Parentesco"
            }  else if titulo == "Artistas" {
                viewDetalles.tituloModificar = "Modificar Artista"
                viewDetalles.comodin = "Tipo de Artista"
            }
            viewDetalles.colorLabel = colorBar
            viewDetalles.personaDicc = personaDicc
            viewDetalles.indexPath = indexPath
            viewDetalles.anterior = self
            
        } else {
            // Vista para agregar persona
            
            let viewAgregar = segue.destination as! ViewControllerAgregarPersona
            
            if titulo == "Conocidos" {
                viewAgregar.comodin = "Conocido de"
                viewAgregar.nombrePantalla = "Agregar Conocido"
            } else if titulo == "Familiares" {
                viewAgregar.comodin = "Parentesco"
                viewAgregar.nombrePantalla = "Agregar Familiar"
            }  else if titulo == "Artistas" {
                viewAgregar.comodin = "Tipo de Artista"
                viewAgregar.nombrePantalla = "Agregar Artista"
            }
            viewAgregar.anterior = self
        }
    }
    
    // Configuracion de Navigation Bar
    func cambiarBarra() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "FFFFFF")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(hex: "FFFFFF")]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
	
    // MARK: - Metodos que agregan a una persona
    
    // Funcion que agrega un persona
    func agregaPersona(personaDicc: NSDictionary) {
        
        listaPersonas.add(personaDicc)
        tableView.reloadData()
    }
    
    // Funcion que modifica una persona
    func modificaPersona(personaDicc: NSDictionary, at: IndexPath) {
        
        //let indexPath = tableView.indexPathForSelectedRow
        listaPersonas.replaceObject(at: at.row, with: personaDicc)
        tableView.reloadData()
    }
    
    // Funcion que elimina una persona
    func eliminaPersona(at: IndexPath) {
        listaPersonas.removeObject(at: at.row)
        tableView.reloadData()
    }
	
    // Funcion que escribe los momentos en una plist
	func guardaInformacion() {
		print("Funciono:" + String(listaPersonas.write(toFile: dataFilePath(), atomically: true)))
	}
	
	// Funcion que obtiene la ruta de escritura de datos
	func dataFilePath() -> String {
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		let documentDirectory = paths[0] + "/\(titulo.lowercased())-" + idUsuario + ".plist"
		print(documentDirectory)
		
		return documentDirectory
	}
	
	override func viewWillDisappear(_ animated : Bool) {
		super.viewWillDisappear(animated)
        cambiarBarra()
	}
    
    // MARK: - Funciones de bloqueo de Orientación
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}
