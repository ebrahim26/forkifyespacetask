//
//  RecipeModel.swift
//  ForkKeyEspaceTask
//
//  Created by Ebrahim abdelhamid on 12/05/2021.
//

import Foundation
import RealmSwift
public class RecipeModel {
var publisherName = ""
var title = ""
var recipe_id = ""
var image_url = ""
var ingredients = [String]()
var source_url = ""
}
struct RecipeCellViewModel {

    var publisherName: String
    var title : String
    var recipe_id : String
    var image_url : String
}

class PreviousSearchClass: Object {
    @objc dynamic var title = ""
    override static func primaryKey() -> String? {
            return "title"
        }
}
public enum State {
    case error
}
