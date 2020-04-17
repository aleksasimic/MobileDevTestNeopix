import UIKit
import RxSwift
import RxCocoa

class OrdersListViewController: UIViewController, Storyboarded {
    static var storyboardName = "Orders"
    
    var coordinator: Orderable?
    var viewModelBuilder: OrdersListViewModelBuilder?
    var dataSource: OrdersListDataSource!
    
    private let bag = DisposeBag()
    let fetchMoreOrdersTrigger = PublishSubject<Void>()
    let headerViewPositionUpdateSubject = PublishSubject<(CGFloat, Bool)>()
    
    @IBOutlet weak var ordersTitleLabel: UILabel!
    @IBOutlet weak var totalAmountTitleLabel: UILabel!
    @IBOutlet weak var totalAmountValueLabel: UILabel!
    @IBOutlet weak var distributorImageView: UIImageView!
    @IBOutlet weak var ordersHeaderView: UIView!
    @IBOutlet weak var ordersTableView: UITableView!
    
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension OrdersListViewController {
    func setup() {
        setupUI()
        setupViewModel()
    }
    
    func setupViewModel() {
        if let viewModel = createViewModel() {
            bindViewModel(viewModel)
            setupDataSource(withData: viewModel.ordersWithSections,
                            distributorData: viewModel.distributorData)
            bindActions()
        }
    }
    
    func createViewModel() -> OrdersListViewModel? {
        return viewModelBuilder?(loadTrigger, fetchMoreOrdersTrigger)
    }
    
    func bindViewModel(_ viewModel: OrdersListViewModel) {
        viewModel.distributorLogoUrl
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.distributorImageView.cacheableImage(fromUrl: $0)
                self?.addDistributorImageToNavigation(fromUrl: $0)
            })
            .disposed(by: bag)
        
        viewModel.totalAmountString
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.totalAmountValueLabel.text = $0
            })
            .disposed(by: bag)
    }
    
    func setupDataSource(withData data: Observable<[OrdersSection]>,
                         distributorData: Observable<(String, String)>) {
        dataSource = createDataSource(withData: data)
        bindDataSource(dataSource, distributorData)
    }
    
    func createDataSource(withData data: Observable<[OrdersSection]>) -> OrdersListDataSource {
        return OrdersListDataSource(withTableView: ordersTableView, orders: data, fetchMoreOrdersTrigger: fetchMoreOrdersTrigger, headerViewPositionUpdateTrigger: headerViewPositionUpdateSubject)
    }
    
    func bindDataSource(_ dataSource: OrdersListDataSource,
                        _ distributorData: Observable<(String, String)>) {
        Observable
            .combineLatest(dataSource.selected, distributorData)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.showOrderDetails(withOrderId: $0.0,
                                                    distributorName: $0.1.1,
                                                    distributorLogoUrl: $0.1.0)
            })
            .disposed(by: bag)
    }
    
    func bindActions() {
        headerViewPositionUpdateSubject.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.setupTopViewHeightConstraint(offset: $0.0, scrollingDown: $0.1)
            })
            .disposed(by: bag)
    }
}

private extension OrdersListViewController {
    func setupTopViewHeightConstraint(offset: CGFloat, scrollingDown: Bool) {
        if scrollingDown {
            if topViewHeightConstraint.constant >= 0 {
                if topViewHeightConstraint.constant - offset <= 0 {
                    topViewHeightConstraint.constant = 0
                } else {
                    topViewHeightConstraint.constant -= offset
                }
            }
        } else  {
            if topViewHeightConstraint.constant < 88 {
                if topViewHeightConstraint.constant + offset >= 88 {
                    topViewHeightConstraint.constant = 88
                } else {
                    topViewHeightConstraint.constant += offset
                }
            }
        }
        
        if topViewHeightConstraint.constant <= 0 && navigationController?.navigationBar.isHidden ?? true {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
        
        if topViewHeightConstraint.constant > 0 && !(navigationController?.navigationBar.isHidden ?? true) {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    func addDistributorImageToNavigation(fromUrl url: String) {
        let distributorImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        distributorImageView.cacheableImage(fromUrl: url)
        distributorImageView.setRoundedCorners(withBorderWidth: 1.0, withBorderColor: UIColor.distributorLogoBorderColor())
        
        let buttonItem = UIBarButtonItem(customView: distributorImageView)
        self.navigationItem.rightBarButtonItem = buttonItem
    NSLayoutConstraint.activate([(self.navigationItem.rightBarButtonItem?.customView!.heightAnchor.constraint(equalToConstant: 32))!,
                                 (self.navigationItem.rightBarButtonItem?.customView!.widthAnchor.constraint(equalToConstant: 32))!])
    }
}

private extension OrdersListViewController {
    func setupUI() {
        setupLabels()
        setupNavigation()
        ordersHeaderView.layer.applySketchShadow(color: UIColor.ordersTableViewShadowColor(),
                                                 alpha: 1.0, x: 0, y: 4, blur: 24, spread: 0)
    }
    
    func setupLabels() {
        ordersTitleLabel.text = String.OrdersTitle
        totalAmountValueLabel.text = String.TotalAmountTitle.uppercased()
    }
    
    func setupNavigation() {
        navigationItem.title = String.OrdersTitle
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Metropolis-SemiBold", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.navigationItemTextColor()]
        navigationController?.navigationBar.layer.applySketchShadow(color: UIColor.navigationItemShadowColor(),
                                                                    alpha: 1.0, x: 0, y: 1, blur: 0, spread: 0)
        navigationController?.navigationBar.layer.applySketchShadow(color: UIColor.ordersTableViewShadowColor(),
                                                                    alpha: 1.0, x: 0, y: 4, blur: 12, spread: 0)
    }
}

private extension String {
    static let OrdersTitle      = "Orders"
    static let TotalAmountTitle = "Total Amount For Accepted Orders"
}
