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

	private static let placeholderImage = UIImage(named: "Logo")!

	override func awakeFromNib() {
		super.awakeFromNib()
		containerView.layer.cornerRadius = 5
	}

	func set(_ viewModel: CharacterViewModel) {
		nameLabel.text = viewModel.name
		setImage(from: viewModel.imageURL)
	}

	private func setImage(from url: URL?) {
		characterImageView.af.cancelImageRequest()
		guard let url = url else {
			characterImageView.image = nil
			return
		}
		characterImageView.af.setImage(withURL: url, placeholderImage: CharacterTableViewCell.placeholderImage)
	}
}
