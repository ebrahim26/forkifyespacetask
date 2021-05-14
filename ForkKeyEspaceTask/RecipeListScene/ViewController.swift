//
//  ViewController.swift
//  ForkKeyEspaceTask
//
//  Created by Ebrahim abdelhamid on 12/05/2021.
//

import UIKit
import Kingfisher
import RealmSwift
import Realm
class ViewController: UIViewController {

    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var recipeTableView: UITableView!
    var isSearching = false
    var searchedQuery = [String]()
    lazy var viewModel: RecipeListViewModel = {
        return RecipeListViewModel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initView()
        initVM()
    }
func initView(){
    recipeTableView.delegate = self
    recipeTableView.dataSource = self
    searchText.delegate = self
    navigationController?.navigationBar.isHidden = true
    let realm = try! Realm()
    let notes = realm.objects(PreviousSearchClass.self)
    print(notes.count, "count")
    }
   
func initVM(){
        viewModel.reloadTableViewClosure = { [weak self] () in
                    DispatchQueue.main.async {
                        self?.isSearching = false
                        
                        self?.recipeTableView.reloadData()
                        
                    }
                }
                
   //
    }


}
extension ViewController:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedQuery.count
        }else{
      return  viewModel.numberOfCells
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellGradient", for: indexPath)
            cell.textLabel?.text = searchedQuery[indexPath.row]
            return cell
        }else{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecipeTableViewCell else {
                fatalError("Cell not exists in storyboard")
            }
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.recipeListCellViewModel = cellVM
       
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            viewModel.initFetch(queryParamatter:searchedQuery[indexPath.row])
            let realm = try! Realm()
            do {
                    let realm = try Realm()

                    if let obj = realm.objects(PreviousSearchClass.self).filter("title = %@",searchedQuery[indexPath.row] ).first {

                        //Delete must be perform in a write transaction

                        try! realm.write {
                             realm.delete(obj)
                         }
                    }

                } catch let error {
                    print("error - \(error.localizedDescription)")
                }
            let previousSearchObject = PreviousSearchClass()
            previousSearchObject.title = searchedQuery[indexPath.row]
           
            try! realm.write {
                realm.add(previousSearchObject)
            }
        }else{
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        let recipeId = cellVM.recipe_id
        print("id" , recipeId)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as? RecipeDetailsViewController {
            vc.recipeId = recipeId
          
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    }
    
    
}
extension ViewController : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
           if textField == searchText {
            if  searchText.text != "" {
             //  print("hiiiiiii")
                searchedQuery = queryString.filter({ (mod) -> Bool in
              return mod.lowercased().contains(searchText.text!.lowercased())
                    })
     //    .filter({$0.first_name!.contains("tes")})
                isSearching = true
                recipeTableView.reloadData()
      //  view.endEditing(true)
            } else {
                isSearching = false
                recipeTableView.reloadData()
     //   view.endEditing(true)
            }
                      }
       }
}
