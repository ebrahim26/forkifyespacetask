//
//  RecipeTableViewCell.swift
//  ForkKeyEspaceTask
//
//  Created by Ebrahim abdelhamid on 12/05/2021.
//

import UIKit
import Kingfisher
class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var recipeTitle: UILabel!
    
    @IBOutlet weak var recipePublisherName: UILabel!
    var recipeListCellViewModel : RecipeCellViewModel? {
           didSet {
            recipeTitle.text = recipeListCellViewModel?.title
            recipePublisherName.text = recipeListCellViewModel?.publisherName
            let urls = URL(string:recipeListCellViewModel?.image_url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? "")
            recipeImage.kf.setImage(with: urls!,placeholder: UIImage(named:"profileImage"))
            recipeImage.kf.indicatorType = .activity
           }
       }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
