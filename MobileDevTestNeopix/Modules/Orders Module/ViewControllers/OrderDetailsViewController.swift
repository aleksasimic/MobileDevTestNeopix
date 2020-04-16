import UIKit
import RxSwift
import RxCocoa

class OrderDetailsViewController: UIViewController, Storyboarded {
    static var storyboardName = "Orders"
    
    var coordinator: Orderable?
    var viewModelBuilder: OrderDetailsViewModelBuilder?
    
    private let bag = DisposeBag()
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var viewVenueInfoButton: UIButton!
    @IBOutlet weak var orderStatusLabel: PaddingLabel!
    @IBOutlet weak var orderNumberTitleLabel: UILabel!
    @IBOutlet weak var orderNumberDescriptionLabel: UILabel!
    @IBOutlet weak var requestedOnTitleLabel: UILabel!
    @IBOutlet weak var requestedOnValueLabel: UILabel!
    @IBOutlet weak var acceptedOnTitleLabel: UILabel!
    @IBOutlet weak var acceptedOnValueLabel: UILabel!
    
    @IBOutlet weak var orderDetailsInfoView: UIView!
    @IBOutlet weak var tabButtonsView: UIView!
    
    @IBOutlet weak var productsTabLabel: UILabel!
    @IBOutlet weak var notesTabLabel: UILabel!
    @IBOutlet weak var productsTabIndicator: UIView!
    @IBOutlet weak var notesTabIndicator: UIView!
    @IBOutlet weak var productsTabButton: UIButton!
    @IBOutlet weak var notesTabButton: UIButton!
    
    
    @IBOutlet weak var totalAmountTitleLabel: UILabel!
    @IBOutlet weak var totalAmountValueLabel: UILabel!
    @IBOutlet weak var acceptButtonView: GradientView!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var notesTableView: UITableView!
    
    @IBOutlet weak var productHeaderProductName: UILabel!
    @IBOutlet weak var productHeaderTotalAmount: UILabel!
    
    @IBOutlet weak var noNotesTitle: UILabel!
    @IBOutlet weak var noNotesDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension OrderDetailsViewController {
    func setup() {
        setupUI()
        setupViewModel()
        bindActions()
    }
    
    func setupViewModel() {
        if let viewModel = createViewModel() {
            bindViewModel(viewModel)
        }
    }
    
    func createViewModel() -> OrderDetailsViewModel? {
        return viewModelBuilder?(loadTrigger)
    }
    
    func bindViewModel(_ viewModel: OrderDetailsViewModel) {
        viewModel.order
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: bag)
    }
    
    func bindActions() {
        closeButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.closeOrderDetails()
            })
            .disposed(by: bag)
        
        acceptButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.closeOrderDetails()
            })
            .disposed(by: bag)
    }
}

private extension OrderDetailsViewController {
    func setupUI() {
        setupLabels()
        venueImageView.setRoundedCorners()
    }
    
    func setupLabels() {
        orderNumberTitleLabel.text = String.OrderNumber
        requestedOnTitleLabel.text = String.OrderedAt
        acceptedOnTitleLabel.text = String.AcceptedAt
    }
}

private extension String {
    static let OrderNumber = "Order number".uppercased()
    static let OrderedAt   = "Ordered at".uppercased()
    static let AcceptedAt  = "Accepted at".uppercased()
    static let NotAccepted = "N/A"
}

