//
//  RecipeDetailsInteractor.swift
//  ForkKeyEspaceTask
//
//  Created by Ebrahim abdelhamid on 12/05/2021.
//

import Foundation
import SwiftyJSON
import Alamofire

class  GetRecipeInteractor {
   
    var recipeDetailObject = RecipeModel()
    func getRecipeDetails(recipeId: String , cb : @escaping (RecipeModel,Error?) -> () ){
        let url = URL(string: "https://forkify-api.herokuapp.com/api/get?rId=\(recipeId)")
        AF.request(url! , method: .get, headers: nil ).responseJSON { (response) in

            _ = response.data
            do {
                let json = JSON(response.data)
        
                 print(json)

                self.recipeDetailObject.publisherName = json["recipe"]["publisher"].string ?? ""
                self.recipeDetailObject.title = json["recipe"]["title"].string ?? ""
                self.recipeDetailObject.recipe_id = json["recipe"]["recipe_id"].string ?? ""
                self.recipeDetailObject.image_url = json["recipe"]["image_url"].string ?? ""
                self.recipeDetailObject.source_url = json["recipe"]["source_url"].string ?? ""
                let recipeIngridentArray = json["recipe"]["ingredients"].arrayValue
                self.recipeDetailObject.ingredients = recipeIngridentArray.map { $0.stringValue}
                cb(self.recipeDetailObject, nil )


            }catch {
             //   UIViewController.removeSpinner(spinner: sv)
                print("error")
                cb(self.recipeDetailObject, response.error)
            }

        }
        
    }
    
    
    
}
