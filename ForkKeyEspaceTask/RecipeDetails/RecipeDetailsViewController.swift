//
//  RecipeDetailsViewController.swift
//  ForkKeyEspaceTask
//
//  Created by Ebrahim abdelhamid on 12/05/2021.
//

import UIKit
import SafariServices
import Kingfisher
class RecipeDetailsViewController: UIViewController,RecipeViewProtocol,SFSafariViewControllerDelegate {
    func fetchingRecipeSuccess(recipeObject: RecipeModel) {
        recipeDetailsObject = recipeObject
        tableView.reloadData()
    }
    
    func serverEerror(error: String) {
        print("error")
    }
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var recipeId = ""
    var recipeDetailsObject = RecipeModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        initPresenter()
    }
    
    var presenter: RecipeDetailsPresenter!
    func initView(){
        tableView.delegate = self
        tableView.dataSource = self
        presenter = RecipeDetailsPresenter(view: self)
        
    }
    func initPresenter(){
        presenter.getRecipeDetails(recipeId: recipeId)
    }
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    

}
extension RecipeDetailsViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if  section == 1{
            return 1
        }else if  section == 2 {
            return recipeDetailsObject.ingredients.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellImage", for: indexPath) as? RecipeImageTableViewCell else {
                    fatalError("Cell not exists in storyboard")
                
                }
//            let url = URL(string:recipeDetailsObject.image_url ?? "")
//            cell.imageView?.kf.setImage(with: url)
            let urls = URL(string:recipeDetailsObject.image_url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? "")
            cell.imageView?.kf.setImage(with: urls)
            cell.imageView?.kf.indicatorType = .activity
            cell.selectionStyle = .none
            return cell
        }else if  indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = recipeDetailsObject.title
            cell.selectionStyle = .none
            return cell
        }else if  indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = recipeDetailsObject.ingredients[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = recipeDetailsObject.source_url
            cell.selectionStyle = .none
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
         return 4
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "image"
        }else if  section == 1{
            return "title"
        }else if  section == 2 {
            return "ingrident"
        }else {
            return "soure link"
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
        let urlString = recipeDetailsObject.source_url

        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self

            present(vc, animated: true)
        }
        }
    }
}
