//
//  Rei.swift
//  ForkKeyEspaceTask
//
//  Created by Ebrahim abdelhamid on 12/05/2021.
//

import Foundation
protocol RecipeViewProtocol: class {
    
    func fetchingRecipeSuccess(recipeObject : RecipeModel)
    func  serverEerror(error :String)
    
    
}
class RecipeDetailsPresenter {
    
    private weak var view: RecipeDetailsViewController?
    private let interactor = GetRecipeInteractor()
    
    
    init(view: RecipeDetailsViewController) {
        self.view = view
        
    }
   
    func getRecipeDetails(recipeId: String) {
        interactor.getRecipeDetails(recipeId: recipeId) { (recipeDetailsObject, error) in
            if error != nil {
              

               self.view?.serverEerror(error: "server error")
            } else {
                self.view?.fetchingRecipeSuccess(recipeObject: recipeDetailsObject)
            }
        }
        }
   
   
    
    
   // func codeOkSucess(){
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        if let vc = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
//            vc.email = (self.view?.email)!
//            vc.code = (self.view?.codeText.text )!
//            vc.comingFromSetting = self.view!.comingFromSetting
//            self.view?.navigationController?.pushViewController(vc, animated: true)
//        }
//
//
//    }
//    func messageReturn() -> String {
//        return errorReturn
//    }
    //    func tokenReturn()-> String{
    //
    //        return token
    //    }
    
}
