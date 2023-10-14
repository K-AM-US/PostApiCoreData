//
//  PostCell.swift
//  PostApiCoreData
//
//  Created by Mauricio Casillas on 13/10/23.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet var postCellTitle: UILabel!
    @IBOutlet var postCellBody: UILabel!
    var id: Int16 = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
