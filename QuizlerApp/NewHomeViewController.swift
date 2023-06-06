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
    private var reportTypes: [ReportTypeModel] = []

    struct LocalizationStrings {
        static let kategorijaTitle = "home_view_screen_kategorija_title".localized()
        static let kategorijaDescription = "home_view_screen_kategorija_description".localized()
        static let tezinaTitle = "home_view_screen_tezina_title".localized()
        static let tezinaDescription = "home_view_screen_tezina_description".localized()
        static let duzinaTitle = "home_view_screen_duzina_title".localized()
        static let duzinaDescription = "home_view_screen_duzina_description".localized()
        static let tabBarPocetnaText = "home_view_screen_pocetna_text".localized()
    }
    
    //MARK: - Init

    class func instantiate() -> NewHomeViewController {
        let viewController = UIStoryboard.main.instantiateViewController(withIdentifier: identifier) as! NewHomeViewController
        viewController.tabBarItem = UITabBarItem(title: LocalizationStrings.tabBarPocetnaText, image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home"))
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
        self.fetchBackgroundColorFromDB()
        
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
        
        self.apiFetchReportTypes { [weak self] reportTypes in
            guard let self = self else { return }
            self.reportTypes = reportTypes
        }
        
    }

    
    // MARK: - Utils
    
    private func prepareThemeAndLocalization() {
        //Theme
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        
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
            cell.configure(with: LocalizationStrings.kategorijaTitle, description: LocalizationStrings.kategorijaDescription, data: model.submodes, questions: questionsDataSource, reportTypes: reportTypes)
            return cell
        } else if indexPath.row == 1 {
            guard let model = dataSource.first(where: { $0.name == "difficulty"}) else { return UITableViewCell() }
            cell.configure(with: LocalizationStrings.tezinaTitle, description: LocalizationStrings.tezinaDescription, data: model.submodes, questions: questionsDataSource, reportTypes: reportTypes)
            return cell
        } else if indexPath.row == 2 {
            guard let model = dataSource.first(where: { $0.name == "length"}) else { return UITableViewCell() }
            cell.configure(with: LocalizationStrings.duzinaTitle, description: LocalizationStrings.duzinaDescription, data: model.submodes, questions: questionsDataSource, reportTypes: reportTypes)
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
    
    private func apiFetchReportTypes(_ callback: @escaping ([ReportTypeModel])->Swift.Void) {
        let loader = LoaderView.create(for: self.view, config: AppGlobals.defaultLoadConfig)
        
        AppGlobals.herokuRESTManager.getReportTypes { (result) in
            loader.dismiss()
            switch result {
            case .success(let dataSource): callback(dataSource)
            case .failure: break
            }
        }
    }
    
    private func fetchBackgroundColorFromDB() {
        if let colorData: Data = AppGlobals.standardLocalStorage.loadCodable("SELECTED_HOME_COLOR"),
           let backgroundColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
            self.view.backgroundColor = backgroundColor
        } else {
            self.view.backgroundColor = AppTheme.current.mainColor
        }
    }
}

