//
//  CharacterTableViewCell.swift
//  BreakingBadExplorer
//
//  Created by Rastislav Smolen on 10/09/20.
//  Copyright © 2020 Rastislav Smolen. All rights reserved.
//

import UIKit
import AlamofireImage

class CharacterTableViewCell: UITableViewCell {

	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var characterImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		containerView.layer.cornerRadius = 5
	}

	func set(_ viewModel: CharacterViewModel) {
		nameLabel.text = viewModel.name

		characterImageView.af.cancelImageRequest()

		if let url = viewModel.imageURL {
			characterImageView.af.setImage(withURL: url) { [weak self] (dataResponse) in
				switch dataResponse.result {
				case .failure: self?.characterImageView.image = nil
				default: break
				}
			}
		} else {
			characterImageView.image = nil
		}
	}
}
