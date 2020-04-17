import UIKit
import RxSwift
import RxCocoa

class VenueInfoViewController: UIViewController, Storyboarded {
    
    static var storyboardName = "Orders"
    
    var coordinator: Orderable?
    var viewModelBuilder: VenueInfoViewModelBuilder?
    
    private let bag = DisposeBag()

    @IBOutlet weak var venueInfoLabel: UILabel!
    @IBOutlet weak var closeVenueInfoButton: UIButton!
    @IBOutlet weak var primaryNameLabel: UILabel!
    @IBOutlet weak var primaryPhoneLabel: UILabel!
    @IBOutlet weak var secondaryNameLabel: UILabel!
    @IBOutlet weak var secondaryPhoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension VenueInfoViewController {
    func setup() {
        setupViewModel()
        bindActions()
        setupUI()
    }
    
    func setupViewModel() {
        if let viewModel = createViewModel() {
            bindViewModel(viewModel)
        }
    }
    
    func createViewModel() -> VenueInfoViewModel? {
        return viewModelBuilder?()
    }
    
    func bindViewModel(_ viewModel: VenueInfoViewModel) {
        viewModel.primaryContactName
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.primaryNameLabel.text = $0
            })
            .disposed(by: bag)
        
        viewModel.primaryContactPhone
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.primaryPhoneLabel.text = $0
            })
            .disposed(by: bag)
        
        viewModel.secondaryContactName
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.secondaryNameLabel.text = $0
            })
            .disposed(by: bag)
        
        viewModel.secondaryContactPhone
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.secondaryPhoneLabel.text = $0
            })
            .disposed(by: bag)
        
        viewModel.address
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.addressLabel.text = $0
            })
            .disposed(by: bag)

    }
    
    func bindActions() {
        closeVenueInfoButton.rx.tap.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.closeVenueInfo()
            })
            .disposed(by: bag)
    }
}

private extension VenueInfoViewController {
    func setupUI() {
        setupLabels()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    func setupLabels() {
        venueInfoLabel.text = String.VenueInfo
    }
}

private extension String {
    static let VenueInfo = "Venue Info"
}
