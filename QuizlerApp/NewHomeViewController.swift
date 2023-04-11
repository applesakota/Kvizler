//
//  NewHomeViewController.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 2/6/23.
//

import UIKit

class NewHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Globals

    class var identifier: String { return "NewHomeViewController" }
    
    @IBOutlet weak var tableView: UITableView!
    private var dataSource: [CategoryModel] = []
    private var questionsDataSource: QuestionsViewModel?
    
    //MARK: - Init

    class func instantiate() -> NewHomeViewController {
        let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: identifier) as! NewHomeViewController
        viewController.tabBarItem = UITabBarItem(title: "Pocetna", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home"))
        return viewController
    }
    
    class func instantiateWithNavigation() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: instantiate())
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.backgroundColor = UIColor.clear
        return navigationController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: QuizlerTableViewCell.identifier, bundle: nibBundle), forCellReuseIdentifier: QuizlerTableViewCell.identifier)
        self.tableView.separatorStyle = .none
        self.prepareThemeAndLocalization()
        
        
        self.apiFetchCategories { [weak self] dataSource in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dataSource = dataSource
                self.tableView.reloadData()
            }
        }
        
        self.fetchQuestions { [weak self] questions in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.questionsDataSource = QuestionsViewModel(questions: questions)
                self.tableView.reloadData()
            }
        }
        
    }
    
    // MARK: - Utils
    
    private func prepareThemeAndLocalization() {
        //Theme
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    // MARK: - API
    
    private func apiFetchCategories(_ callback: @escaping ([CategoryModel])->Swift.Void) {
        let loader = LoaderView.create(for: self.view, config: AppGlobals.defaultLoadConfig)
        
        AppGlobals.herokuRESTManager.getModes { (result) in
            loader.dismiss()
            switch result {
            case .success(let dataSource): callback(dataSource)
            case .failure: break
            }
        }
    }
    
    //MARK: - DataSource / Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuizlerTableViewCell.identifier) as? QuizlerTableViewCell else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            guard let model = dataSource.first(where: { $0.name == "category"}) else { return UITableViewCell() }
            cell.configure(with: "Kategorija", description: "Mislis da dobro poznajes Majkla Dzeksona, ili pak bolje znas de trenutno igra Mbappe? Oprobaj se u jednom od modova kategorije", data: model.submodes, questions: questionsDataSource)
            return cell
        } else if indexPath.row == 1 {
            guard let model = dataSource.first(where: { $0.name == "length"}) else { return UITableViewCell() }
            cell.configure(with: "Duzina", description: "Ako si u guzvi, ili pak imas dosta vremena, odigraj jednu od modova po duzini. Respektivno, oni imaju 20,50, odnosno 100 pitanja.", data: model.submodes, questions: questionsDataSource)
            return cell
        } else if indexPath.row == 2 {
            guard let model = dataSource.first(where: { $0.name == "difficulty"}) else { return UITableViewCell() }
            cell.configure(with: "Tezina", description: "Lak, srednji ili tezak mod, Na tebi je koliko si hrabra/hrabar!", data: model.submodes, questions: questionsDataSource)
            return cell
        }
        
        return UITableViewCell()
    }
    
    //MARK: - API
    
    func fetchQuestions(_ callback: @escaping ([QuestionModel])->Swift.Void) {
        let loader = LoaderView.create(for: self.view, config: AppGlobals.defaultLoadConfig)
        AppGlobals.herokuRESTManager.getQuestions { (result) in
            loader.dismiss()
            switch result {
            case .success(let questions): callback(questions)
            case .failure: break
            }
        }
    }
}

