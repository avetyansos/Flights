//
//  SearchResultViewController.swift
//  RyanAirTestApplication
//

import UIKit

protocol SearchResultDisplayLogic: AnyObject {

}

class SearchResultViewController: UIViewController, SearchResultDisplayLogic
{
    var interactor: SearchResultBusinessLogic?
    var router: (NSObjectProtocol & SearchResultRoutingLogic & SearchResultDataPassing)?
    @IBOutlet weak var tableView: UITableView!
    var trips = [Trip]()
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = SearchResultInteractor()
        let presenter = SearchResultPresenter()
        let router = SearchResultRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
}

extension SearchResultViewController: UITableViewDelegate {
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return trips[0].originName
        } else {
            return trips [1].originName
        }
    }
}

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips[section].dates?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell", for: indexPath) as! SearchResultsTableViewCell
        cell.regularFare = trips[indexPath.section].dates?[indexPath.row]
        
        return cell
    }
    
    
}
