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
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var isSearching = false
    var searchedQuery = [String]()
    let realm = try! Realm()
    var hasPreviousSearch = false
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
        activityIndicator.style = .large
        activityIndicator.color = .black
        activityIndicator.isHidden = true
    }
    
    func initVM(){
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.isSearching = false
                self?.hasPreviousSearch = false
                self?.recipeTableView.reloadData()
                self?.view.endEditing(true)
                self?.activityIndicator.isHidden = true
                self?.activityIndicator.stopAnimating()
            }
        }
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }

            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.viewModel.state {
                case  .error:
                    self.recipeTableView.isHidden = true
                    self.messageLabel.text = "error from server or network connection please try agian"
                    self.activityIndicator.stopAnimating()
          
                }
            }
        }

    }
}
extension ViewController:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedQuery.count
        }
        else if hasPreviousSearch {
            let previousSearchArray = realm.objects(PreviousSearchClass.self)
            if previousSearchArray.count > 10{
            return 10
            }else{
                return previousSearchArray.count
            }
        }
        else{
      return  viewModel.numberOfCells
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellGradient", for: indexPath)
            cell.textLabel?.text = searchedQuery[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        else if hasPreviousSearch {
            let previousSearchArray = realm.objects(PreviousSearchClass.self).reduce([],{ [$1] + $0 })
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellGradient", for: indexPath)
            cell.textLabel?.text = previousSearchArray[indexPath.row].title
            cell.selectionStyle = .none
            return cell
        }
        
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecipeTableViewCell else {
                fatalError("Cell not exists in storyboard")
            }
            let cellVM = viewModel.getCellViewModel( at: indexPath )
            cell.recipeListCellViewModel = cellVM
            cell.selectionStyle = .none
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if hasPreviousSearch {
            return 1
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if hasPreviousSearch {
            return "your previous search"
        }else{
            return ""
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            viewModel.initFetch(queryParamatter:searchedQuery[indexPath.row])
            saveToDatabase(index: indexPath.row)
        }
        else if hasPreviousSearch {
            let previousSearchArray = realm.objects(PreviousSearchClass.self).reduce([],{ [$1] + $0 })
            viewModel.initFetch(queryParamatter:previousSearchArray[indexPath.row].title)
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
        else{
            let cellVM = viewModel.getCellViewModel( at: indexPath )
            let recipeId = cellVM.recipe_id
            print("id" , recipeId)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as? RecipeDetailsViewController {
                vc.recipeId = recipeId
                vc.recipeDetailsTitle = cellVM.title
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func saveToDatabase(index:Int){
        do {
            let realm = try Realm()
            
            if let obj = realm.objects(PreviousSearchClass.self).filter("title = %@",searchedQuery[index] ).first {
                
                //Delete must be perform in a write transaction
                
                try! realm.write {
                    realm.delete(obj)
                }
            }
            
        } catch let error {
            print("error - \(error.localizedDescription)")
        }
        let previousSearchObject = PreviousSearchClass()
        previousSearchObject.title = searchedQuery[index]
        
        try! realm.write {
            realm.add(previousSearchObject)
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
}
extension ViewController : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.recipeTableView.isHidden = false
        self.messageLabel.text = ""
        if textField == searchText {
            if  searchText.text != "" {
                
                searchedQuery = queryString.filter({ (mod) -> Bool in
                    return mod.lowercased().contains(searchText.text!.lowercased())
                })
                
                isSearching = true
                hasPreviousSearch = false
                recipeTableView.reloadData()
                
            } else {
                let previousSearchArray = realm.objects(PreviousSearchClass.self)
                if !previousSearchArray.isEmpty {
                    hasPreviousSearch = true
                    isSearching = false
                    recipeTableView.reloadData()
                }else{
                    isSearching = false
                    hasPreviousSearch = false
                    recipeTableView.reloadData()
                    
                }
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.recipeTableView.isHidden = false
        self.messageLabel.text = ""
        if textField == searchText {
            if  searchText.text == "" {
                let previousSearchArray = realm.objects(PreviousSearchClass.self)
                if !previousSearchArray.isEmpty {
                    hasPreviousSearch = true
                    isSearching = false
                    recipeTableView.reloadData()
                }
            }else{
                isSearching = false
                hasPreviousSearch = false
                recipeTableView.reloadData()
            }
        }
    }
}

