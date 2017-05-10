//  VCDetallesMomento.swift
//  ProyectoRecuerdos

import UIKit
import MediaPlayer
import AVFoundation

class VCDetallesMomento: UIViewController, AVAudioPlayerDelegate {
    
    // Declaracion de elementos de interfaz
    @IBOutlet weak var lbNombre: UILabel!
    @IBOutlet weak var imagenFoto: UIImageView!
    @IBOutlet weak var lbFecha: UILabel!
    @IBOutlet weak var tfDescripcion: UITextView!
    
    // Declaracion de variables
    var anterior : TableViewControllerMomentos!     // Apuntador a Tabla de Momentos
    var momentoDicc : NSDictionary!                 // Informacion del momento
    var indexPath : IndexPath!
    
    // Declaracion de elementos para musica
    var songURL: URL? = nil
    var audioPlayer: AVAudioPlayer!
    var reproduciendo = false
    
    // Configuracion de los elementos de interfaz del boton de musica
    @IBOutlet weak var nombreCancion: UILabel!
    @IBOutlet weak var nombreArtista: UILabel!
    @IBOutlet weak var btMusica: UIButton!
    @IBOutlet weak var viewBTMusica: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuracion de Navigation Bar
        title = "Detalles"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // Muestra la informacion del momento
        lbNombre.text = (momentoDicc.value(forKey: "nombre") as! String)
        
        let fechaSeleccionada = momentoDicc.value(forKey: "fecha") as! Date
        let calendario = Calendar(identifier: .gregorian)
        let formateador = DateFormatter()
        formateador.dateFormat = "MMMM"
        
        let dia = calendario.component(.day, from: fechaSeleccionada)
        let mes = "\(formateador.string(from: fechaSeleccionada))"
        let año = calendario.component(.year, from: fechaSeleccionada)
        
        lbFecha.text = "\(dia) de \(mes) de \(año)"
        tfDescripcion.text = momentoDicc.value(forKey: "descripcion") as! String
        imagenFoto.image = UIImage(data: momentoDicc.value(forKey: "foto") as! Data, scale:1.0)
        
        // Si no existe musica oculta el boton de musica
        let urlCancion = momentoDicc.value(forKey: "musica") as! String
        
        if urlCancion != "" {
            
            let nombreCancionS = momentoDicc.value(forKey: "cancion") as? String
            let nombreArtistaS = momentoDicc.value(forKey: "artista") as? String
            
            nombreArtista.isHidden = false
            nombreArtista.isHidden = false
            btMusica.isHidden = false
            viewBTMusica.isHidden = false
            
            nombreArtista.text = nombreArtistaS
            nombreCancion.text = nombreCancionS
            
        } else {
            
            nombreArtista.isHidden = true
            nombreArtista.isHidden = true
            btMusica.isHidden = true
            viewBTMusica.isHidden = true
            
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let player = audioPlayer {
            btMusica.setImage(#imageLiteral(resourceName: "iconPlay"), for: .normal)
            player.stop()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindEnviar(unwindSegue : UIStoryboardSegue) {
    }
    
    func recargaVista() {
        viewDidLoad();
    }
    
    // Funcion que reproduce una cancion
    @IBAction func reproducirMusica(_ sender: UIButton) {
        
        let cancionURL = momentoDicc.value(forKey: "musica") as! String
        
        if cancionURL != "" {
            
            songURL = URL(string: cancionURL)
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
                    player.play()
                    btMusica.setImage(#imageLiteral(resourceName: "iconPause"), for: .normal)
                } else {
                    btMusica.setImage(#imageLiteral(resourceName: "iconPlay"), for: .normal)
                    player.stop()
                }
            }
        }
    }
    
    // Se llama cuando termina una cancion
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        reproduciendo = !reproduciendo
        
        if let player = audioPlayer {
            btMusica.setImage(#imageLiteral(resourceName: "iconPlay"), for: .normal)
            player.stop()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewModificar = segue.destination as! ViewControllerAgregarMomento
        viewModificar.nombrePantalla = "Modificar Momento"
        viewModificar.momentoDicc = momentoDicc
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
