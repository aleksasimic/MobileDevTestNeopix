import UIKit
import RxSwift
import RxCocoa

class OrderDetailsViewController: UIViewController, Storyboarded {
    static var storyboardName = "Orders"
    
    var coordinator: Orderable?
    var viewModelBuilder: OrderDetailsViewModelBuilder?
    
    private let bag = DisposeBag()
    let topInfoViewUpdateSubject = PublishSubject<(CGFloat, Bool)>()
    let productTableBottomUpdateSubject = PublishSubject<Bool>()
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var viewVenueInfoButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var orderStatusLabel: OrderStatusLabel!
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
    @IBOutlet weak var productsTabIndicatorView: TabIndicatorView!
    @IBOutlet weak var notesTabIndicatorView: TabIndicatorView!
    @IBOutlet weak var productsTabButton: UIButton!
    @IBOutlet weak var notesTabButton: UIButton!
    
    
    @IBOutlet weak var totalAmountTitleLabel: UILabel!
    @IBOutlet weak var totalAmountValueLabel: UILabel!
    @IBOutlet weak var acceptButtonView: GradientView!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var productsTableBottomGradientView: GradientView!
    @IBOutlet weak var notesTableView: UITableView!
    
    @IBOutlet weak var productHeaderProductName: UILabel!
    @IBOutlet weak var productHeaderTotalAmount: UILabel!
    
    @IBOutlet weak var noNotesView: UIView!
    @IBOutlet weak var noNotesTitle: UILabel!
    @IBOutlet weak var noNotesDescription: UILabel!
    
    
    @IBOutlet weak var totalAmountLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var notesTableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderDetailsInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productsTableViewBottomConstraint: NSLayoutConstraint!
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension OrderDetailsViewController {
    func setup() {
        setupUI()
        setupViewModel()
        bindScrollView()
    }
    
    func setupViewModel() {
        if let viewModel = createViewModel() {
            bindViewModel(viewModel)
            bindActions(viewModel)
            setupNotesDataSource(withData: viewModel.notes,
                                 distributorName: viewModel.distributorName,
                                 distributorLogo: viewModel.distributorLogoUrl)
            setupProductsDataSource(withData: viewModel.products)
        }
    }
    
    func createViewModel() -> OrderDetailsViewModel? {
        return viewModelBuilder?(loadTrigger)
    }
    
    func bindViewModel(_ viewModel: OrderDetailsViewModel) {
        viewModel.venueName
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.venueNameLabel.text = $0
            })
            .disposed(by: bag)
        
        viewModel.venueImageUrl
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.venueImageView.cacheableImage(fromUrl: $0)
            })
            
            .disposed(by: bag)
        
        viewModel.orderStatus
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.setupViewsForOrderStatus(status: $0)
            })
            .disposed(by: bag)
        
        viewModel.orderNumber
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.orderNumberDescriptionLabel.text = $0
            })
            .disposed(by: bag)
        
        viewModel.orderedAt
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.requestedOnValueLabel.text = $0.fullDateString
            })
            .disposed(by: bag)
        
        viewModel.acceptedOrDeclinedAt
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.acceptedOnValueLabel.text = $0.fullDateString
            })
            .disposed(by: bag)
        
        viewModel.totalAmount
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.totalAmountValueLabel.text = $0.amountWithCurrencySymbol
            })
            .disposed(by: bag)
        
        viewModel.hideAcceptButton
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.setupHideAcceptOrderButton(shouldHide: $0)
            })
            .disposed(by: bag)
        
        viewModel.hideEmptyNotesView
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.setupNotesView(shouldHide: $0)
            })
            .disposed(by: bag)
    }
    
    func bindActions(_ viewModel: OrderDetailsViewModel) {
        productsTabButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.setupViewForSelectedTabOnScroll(currentPage: 0, shouldScrollToPage: true)
            })
            .disposed(by: bag)
        
        notesTabButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.setupViewForSelectedTabOnScroll(currentPage: 1, shouldScrollToPage: true)
            })
            .disposed(by: bag)
        
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
        
        viewVenueInfoButton.rx.tap.asObservable()
            .withLatestFrom(viewModel.venue)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.showVenueInfo(forVenue: $0)
            })
            .disposed(by: bag)
        
        moreButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.showCancelDeclineOrder()
            })
            .disposed(by: bag)
        
        topInfoViewUpdateSubject.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.setupOrderDetailsHeightConstraint(offset: $0.0, scrollingDown: $0.1)
            })
            .disposed(by: bag)
        
        productTableBottomUpdateSubject.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.setupProductsTableBottomGradientView(shouldPresent: $0)
            })
            .disposed(by: bag)
    }
    
    func setupNotesDataSource(withData data: Observable<[Note]>, distributorName: Observable<String>, distributorLogo: Observable<String>) {
        _ = OrderDetailsNotesDataSource(withTableView: notesTableView,
                                        notes: data,
                                        distributorLogoUrl: distributorLogo,
                                        distributorName: distributorName)
    }
    
    func setupProductsDataSource(withData data: Observable<[Product]>) {
        _ = OrderDetailsProductsDataSource(withTableView: productsTableView,
                                           products: data,
                                           topInfoVewPositionUpdateTrigger: topInfoViewUpdateSubject,
                                           bottomGradientUpdateTrigger: productTableBottomUpdateSubject)
    }
}

private extension OrderDetailsViewController {
    func setupViewsForOrderStatus(status: OrderStatus) {
        orderStatusLabel.setupViewsForOrderStatus(status: status)
        productsTabIndicatorView.setupIndicatorColor(forStatus: status)
        notesTabIndicatorView.setupIndicatorColor(forStatus: status)
        acceptedOnTitleLabel.text = status == .declined ? String.DeclinedAt : String.AcceptedAt
    }
    
    func setupNotesView(shouldHide: Bool) {
        self.noNotesView.isHidden = shouldHide
        self.notesTableView.isHidden = !shouldHide
        notesTableViewTopConstraint.priority = shouldHide ? UILayoutPriority(999.0) : UILayoutPriority.defaultLow
    }
    
    func setupHideAcceptOrderButton(shouldHide: Bool) {
        acceptButtonView.isHidden = shouldHide
        acceptButton.isHidden = shouldHide
        totalAmountLabelBottomConstraint.priority = shouldHide ? UILayoutPriority(999.0) : UILayoutPriority.defaultLow
        totalAmountLabelBottomConstraint.isActive = true
    }
    
    func setupViewForSelectedTabOnScroll(currentPage: Int, shouldScrollToPage: Bool = false) {
        if self.currentPage != currentPage {
            if currentPage == 0 {
                setupProductsPageOne()
            } else if currentPage == 1 {
                setupNotesPageTwo()
            }
            
            if shouldScrollToPage {
                self.scrollToPage(currentPage: currentPage)
            }
            
            self.currentPage = currentPage
        }
    }
    
    func setupProductsPageOne() {
        productsTabIndicatorView.isHidden = false
        notesTabIndicatorView.isHidden = true
        productsTabLabel.textColor = UIColor.white
        notesTabLabel.textColor = UIColor.white.withAlphaComponent(0.48)
    }
    
    func setupNotesPageTwo() {
        productsTabIndicatorView.isHidden = true
        notesTabIndicatorView.isHidden = false
        productsTabLabel.textColor = UIColor.white.withAlphaComponent(0.48)
        notesTabLabel.textColor = UIColor.white
    }
    
    func scrollToPage(currentPage: Int) {
        if currentPage == 0 {
            self.horizontalScrollView.contentOffset.x = 0
        } else if currentPage == 1 {
            self.horizontalScrollView.contentOffset.x = view.frame.width
        }
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setupProductsTableBottomGradientView(shouldPresent: Bool) {
        productsTableViewBottomConstraint.constant = shouldPresent ? 72.0 : 0.0
        productsTableBottomGradientView.isHidden = shouldPresent
    }
}

extension OrderDetailsViewController: UIScrollViewDelegate {
    func bindScrollView() {
        horizontalScrollView.delegate = self
        bindScrollViewActions()
    }
    
    func bindScrollViewActions() {
        horizontalScrollView.rx.didEndDecelerating
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let currentPage = (self?.horizontalScrollView.contentOffset.x ?? 0)/(self?.view.frame.width ?? 1)
                self?.setupViewForSelectedTabOnScroll(currentPage: Int(currentPage))
            })
            .disposed(by: bag)
    }
}

extension OrderDetailsViewController {
    func setupOrderDetailsHeightConstraint(offset: CGFloat, scrollingDown: Bool) {
        if scrollingDown {
            if orderDetailsInfoViewHeightConstraint.constant >= 0 {
                if orderDetailsInfoViewHeightConstraint.constant - offset <= 0 {
                    orderDetailsInfoViewHeightConstraint.constant = 0
                } else {
                    orderDetailsInfoViewHeightConstraint.constant -= offset
                }
            }
        } else  {
            if orderDetailsInfoViewHeightConstraint.constant < 81 {
                if orderDetailsInfoViewHeightConstraint.constant + offset >= 81 {
                    orderDetailsInfoViewHeightConstraint.constant = 81
                } else {
                    orderDetailsInfoViewHeightConstraint.constant += offset
                }
            }
        }
    }
}

private extension OrderDetailsViewController {
    func setupUI() {
        setupLabels()
        setupViews()
    }
    
    func setupLabels() {
        orderNumberTitleLabel.text = String.OrderNumber
        requestedOnTitleLabel.text = String.OrderedAt
        totalAmountTitleLabel.text = String.TotalAmount
        acceptButton.setTitle(String.AcceptOrder, for: .normal)
        acceptedOnValueLabel.text = String.NA
    }
    
    func setupViews() {
        venueImageView.setRoundedCorners()
        acceptButton.layer.applySketchShadow(color: UIColor.acceptOrderShadowColor(),
                                             alpha: 1.0, x: 0, y: 8, blur: 16, spread: -8)
        
        let visible = productsTableView.contentSize.height < productsTableView.frame.height
        setupProductsTableBottomGradientView(shouldPresent: visible)
    }
}

private extension String {
    static let OrderNumber = "Order number".uppercased()
    static let OrderedAt   = "Ordered at".uppercased()
    static let AcceptedAt  = "Accepted at".uppercased()
    static let DeclinedAt  = "Declined at".uppercased()
    static let TotalAmount = "Total Amount:"
    static let AcceptOrder = "Accept order".uppercased()
    static let NA          =  "N/A"
}

