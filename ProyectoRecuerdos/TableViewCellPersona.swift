//
//  TableViewCellFamiliares.swift
//  ProyectoRecuerdos
//
//  Created by DiegoAJV on 15/04/17.
//  Copyright © 2017 alumno. All rights reserved.
//

import UIKit

class TableViewCellPersona: UITableViewCell {

    @IBOutlet weak var imgFamiliar: UIImageView!
    @IBOutlet weak var lbNombreFamiliar: UILabel!
    @IBOutlet weak var lbParentesco: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgFamiliar.imageToCircle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
