//
//  RecipeListApiCall.swift
//  ForkKeyEspaceTask
//
//  Created by Ebrahim abdelhamid on 12/05/2021.
//

import Foundation
import Alamofire
import SwiftyJSON
public class APIService  : APIServiceProtocol {
    var recipeArray = [RecipeModel]()
    func getRecipeList( queryParamatter :String,cb : @escaping ([RecipeModel]?,Error?) -> () ){
        recipeArray.removeAll()
        let url = URL(string: "https://forkify-api.herokuapp.com/api/search?q=\(queryParamatter)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
        AF.request(url! , method: .get, headers: nil ).responseJSON { (response) in

            _ = response.data
            do {
                let json = JSON(response.data)
        
                 print(json)
                let recipeArrayFromApi = json["recipes"].arrayValue
                for data in 0..<recipeArrayFromApi.count {

                    //let data = data.dictionary!
                  //  self.yourExperience.removeAll()
                    let recipeData = RecipeModel()
                        let data = recipeArrayFromApi[data].dictionary!
                    recipeData.publisherName = data["publisher"]?.string ?? ""
                    recipeData.title = data["title"]?.string ?? ""
                    recipeData.recipe_id = data["recipe_id"]?.string ?? ""
                    recipeData.image_url = data["image_url"]?.string ?? ""
                        self.recipeArray.append(recipeData)

                }

                cb( self.recipeArray, nil )


            }catch {
             //   UIViewController.removeSpinner(spinner: sv)
                print("error")
                 cb( []  , response.error)
            }

        }
    }
}
protocol APIServiceProtocol {
    func  getRecipeList(queryParamatter :String, cb : @escaping ([RecipeModel]?,Error?) -> () )
}
