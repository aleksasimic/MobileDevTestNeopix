import UIKit
import RxSwift
import RxCocoa

class OrdersListViewController: UIViewController, Storyboarded {
    static var storyboardName = "Orders"
    
    var coordinator: Orderable?
    var viewModelBuilder: OrdersListViewModelBuilder?
    
    private let bag = DisposeBag()
    let fetchMoreOrdersTrigger = PublishSubject<Void>()
    
    @IBOutlet weak var ordersTitleLabel: UILabel!
    @IBOutlet weak var totalAmountTitleLabel: UILabel!
    @IBOutlet weak var totalAmountValueLabel: UILabel!
    @IBOutlet weak var distributorImageView: UIImageView!
    @IBOutlet weak var ordersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension OrdersListViewController {
    func setup() {
        setupViewModel()
        setupUI()
    }
    
    func setupViewModel() {
        if let viewModel = createViewModel() {
            bindViewModel(viewModel)
            setupDataSource(withData: viewModel.ordersWithSections)
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
            })
            .disposed(by: bag)
        
        viewModel.totalAmountString
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.totalAmountValueLabel.text = $0
            })
            .disposed(by: bag)
    }
    
    func setupDataSource(withData data: Observable<[OrdersSection]>) {
        _ = OrdersListDataSource(withTableView: ordersTableView, orders: data, fetchMoreOrdersTrigger: fetchMoreOrdersTrigger)
    }
}

private extension OrdersListViewController {
    func setupUI() {
        ordersTitleLabel.text = String.OrdersTitle
        totalAmountValueLabel.text = String.TotalAmountTitle.uppercased()
    }
}

private extension String {
    static let OrdersTitle      = "Orders"
    static let TotalAmountTitle = "Total Amount For Accepted Orders"
}
