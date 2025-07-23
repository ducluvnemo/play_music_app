//
//  SongTableViewCell.swift
//  ios_tutorial
//
//  Created by Nguyen Duc on 14/07/2025.
//

import UIKit

final class SongTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbNailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var performerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(song: Song){
        thumbNailImageView.image = UIImage(named: song.thumbnail)
        titleLabel.text = song.name
        performerLabel.text = song.performer
    }
}
