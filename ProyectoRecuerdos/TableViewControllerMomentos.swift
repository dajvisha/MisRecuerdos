//  TableViewControllerMomentos.swift
//  ProyectoRecuerdos

import UIKit

class TableViewControllerMomentos: UITableViewController {

    var listaMomentos2 : NSMutableArray!
    var idUsuario = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // Obtencion de ruta de escritura permantente de datos
        let filePath = dataFilePath()
        
        // Elimina la separacion entre las lineas
        self.tableView.separatorStyle = .none
        
        // Inicializacion de datos de arreglo
        if FileManager.default.fileExists(atPath: filePath) {
            listaMomentos2 = NSMutableArray(contentsOfFile: filePath)
        } else {
            // Inicializacion vacia (Cuando no existe informacion previa)
            listaMomentos2 = NSMutableArray()
        }
        
        navigationItem.title = "Momentos"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaMomentos2.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath)
        
        let momentoDicc = listaMomentos2[indexPath.row] as! NSDictionary
        
        let fechaSeleccionada = momentoDicc.value(forKey: "fecha") as! Date
        let calendario = Calendar(identifier: .gregorian)
        let formateador = DateFormatter()
        formateador.dateFormat = "MMMM"
        
        let dia = calendario.component(.day, from: fechaSeleccionada)
        let mes = "\(formateador.string(from: fechaSeleccionada))"
        let año = calendario.component(.year, from: fechaSeleccionada)
        
        let fecha = "\(dia) de \(mes) de \(año)"
        
        
        cell.textLabel?.text = (momentoDicc.value(forKey: "nombre") as! String)
        cell.detailTextLabel?.text = "Fecha: " + fecha
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Envio de datos a pantalla de Detalles de Momento
        self.navigationController?.navigationBar.isTranslucent = true
        if segue.identifier == "Detalles" {
            let viewDetalles = segue.destination as! VCDetallesMomento
            let indexPath = tableView.indexPathForSelectedRow
            let momentoDicc = listaMomentos2[indexPath!.row] as! NSDictionary
            viewDetalles.momentoDicc = momentoDicc
            viewDetalles.anterior = self
            viewDetalles.indexPath = indexPath
        } else  {
            // Envio de datos a pantalla de Agregar Momento
            let viewAgregar = segue.destination as! ViewControllerAgregarMomento
            viewAgregar.anterior = self
        }
    }
    
    // MARK: - Metodos de modificacion de momentos
    
    // Funcion que obtiene la ruta de escritura de datos
    func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] + "/momentos-" + idUsuario + ".plist"
        print(documentDirectory)
        
        return documentDirectory
    }
    
    // Funcion que agrega un momento
    func agregarMomento(momentoDicc : NSDictionary) {
        listaMomentos2.add(momentoDicc)
        tableView.reloadData()
    }
    
    // Funcion que modifica un momento
    func modificarMomento(momentoDicc: NSDictionary, at: IndexPath) {
        listaMomentos2.replaceObject(at: at.row, with: momentoDicc)
        tableView.reloadData()
    }
    
    // Funcion que elimina un momento
    func eliminaMomento(at: IndexPath) {
        listaMomentos2.removeObject(at: at.row)
        tableView.reloadData()
    }
    
    // Funcion que escribe los momentos en una plist
    func guardaInformacion() {
        print("Funciono:" + String(listaMomentos2.write(toFile: dataFilePath(), atomically: true)))
    }

    // MARK: - Métodos de notificación
    
    // Funcion que guarda infomacion cuando se presiona back
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: - Funciones de bloqueo de Orientación
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}
