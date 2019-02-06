//
//  DownloadTaskCell.swift
//  MultipleDownloadSample
//
//  Created by CompIndia on 02/01/19.
//  Copyright © 2019 joprithivi. All rights reserved.
//

import UIKit

class DownloadTaskCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateDisplay(progress: Float, totalSize : String) {
        progressBar.progress = progress
        progressLbl.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
