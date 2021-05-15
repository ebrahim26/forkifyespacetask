//
//  RecipeViewModel.swift
//  ForkKeyEspaceTask
//
//  Created by Ebrahim abdelhamid on 12/05/2021.
//

import Foundation

class RecipeListViewModel {
    
    let apiService: APIServiceProtocol

    private var recipeModelList: [RecipeModel] = [RecipeModel]()
    
    private var cellViewModels: [RecipeCellViewModel] = [RecipeCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    var state: State = .error
        
       
    var numberOfCells: Int {
        return cellViewModels.count
    }
    var recipeModel: RecipeModel?

    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func initFetch(queryParamatter :String) {
        apiService.getRecipeList(queryParamatter :queryParamatter){ [weak self] (recipeList, error) in
            guard let self = self else {
                return
            }

            guard error == nil else {
                self.state = .error
                return
            
            }

            self.processFetchedRecipe(recipeModelList: recipeList!)
        }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> RecipeCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( recipeModel: RecipeModel ) -> RecipeCellViewModel {

        return RecipeCellViewModel(publisherName: recipeModel.publisherName, title:recipeModel.title, recipe_id: recipeModel.recipe_id, image_url: recipeModel.image_url)
    }
    
    private func processFetchedRecipe( recipeModelList: [RecipeModel] ) {
        self.recipeModelList = recipeModelList // Cache
        var vms = [RecipeCellViewModel]()
        for recipe in recipeModelList {
            vms.append( createCellViewModel(recipeModel: recipe) )
        }
        self.cellViewModels = vms
    }
    
}
var queryString = ["carrot","broccoli","asparagus","cauliflower","corn","cucumber","green pepper","lettuce","mushrooms","onion","potato","pumpkin","red pepper","tomato","beetroot","brussel sprouts","peas","zucchini","radish","sweet potato","artichoke","leek","cabbage","celery","chili","garlic","basil","coriander","parsley","dill","rosemary","oregano","cinnamon","saffron","green bean","bean","chickpea","lentil","apple","apricot","avocado","banana","blackberry","blackcurrant","blueberry","boysenberry","cherry","coconut","fig","grape", "grapefruit" , "kiwifruit","lemon","lime","lychee","mandarin","mango","melon","nectarine","orange","papaya","passion fruit","peach","pear","pineapple","plum","pomegranate","quince","raspberry","strawberry","watermelon","salad","pizza","pasta","popcorn","lobster","steak","bbq","pudding","hamburger","pie","cake","sausage","tacos","kebab","poutine","seafood","chips","fries","masala","paella","som tam","chicken","toast","marzipan","tofu","ketchup","hummus","chili","maple syrup","parma ham","fajitas","champ","lasagna","poke","chocolate","croissant","arepas","bunny chow","pierogi","donuts","rendang","sushi","ice cream","duck","curry","beef","goat","lamb","turkey","pork","fish","crab","bacon","ham","pepperoni","salami","ribs"]

