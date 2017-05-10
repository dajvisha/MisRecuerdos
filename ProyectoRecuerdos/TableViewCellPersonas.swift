//
//  TableViewCellPersonas.swift
//  ProyectoRecuerdos
//
//  Created by alumno on 3/22/17.
//  Copyright © 2017 alumno. All rights reserved.
//

import UIKit

class TableViewCellPersonas: UITableViewCell {

    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var lbComodin1: UILabel!
    @IBOutlet weak var lbComodin2: UILabel!
    @IBOutlet weak var lbNombre: UILabel!
	
	var nombre : String = ""
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		imgFoto.imageToCircle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
