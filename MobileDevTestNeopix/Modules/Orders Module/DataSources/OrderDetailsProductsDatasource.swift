import RxSwift

class OrderDetailsProductsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var data: [Product] = []
    private let tableView: UITableView
    private let bag = DisposeBag()
    private let topInfoViewPositionUpdateSubject: PublishSubject<(CGFloat, Bool)>
    private let bottomGradientUpdateSubject: PublishSubject<Bool>
    
    private var distributorLogoUrl: String?
    private var distributorName: String?
    private var lastContentOffset: CGFloat
    private var lastCellVisible: Bool
    
    init(withTableView tableView: UITableView,
         products: Observable<[Product]>,
         topInfoVewPositionUpdateTrigger: PublishSubject<(CGFloat, Bool)>,
         bottomGradientUpdateTrigger: PublishSubject<Bool>) {
        self.tableView = tableView
        self.lastContentOffset = 0
        self.lastCellVisible = false
        self.topInfoViewPositionUpdateSubject = topInfoVewPositionUpdateTrigger
        self.bottomGradientUpdateSubject = bottomGradientUpdateTrigger
        super.init()
        setupTableView()
        setupUpdate(withData: products)
    }
    
    private func setupUpdate(withData data: Observable<[Product]>) {
        data
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                self.reload(withData: $0)
            })
            .disposed(by: bag)
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func reload(withData data: [Product]) {
        self.data = data
        let rect = tableView.rectForRow(at: IndexPath(row: data.count-1, section: 0))
        self.lastCellVisible = tableView.bounds.contains(rect)
        self.reload()
    }
    
    private func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension OrderDetailsProductsDataSource {
    func getItem(atIndexPath indexPath: IndexPath) -> Product? {
        guard data.count > indexPath.row else { return nil }
        return data[indexPath.row]
    }
}

extension OrderDetailsProductsDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let product = getItem(atIndexPath: indexPath) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as! ProductTableViewCell
        
        cell.setup(withProduct: product)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
}

extension OrderDetailsProductsDataSource: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            topInfoViewPositionUpdateSubject.onNext((scrollView.contentOffset.y - self.lastContentOffset, true))
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            topInfoViewPositionUpdateSubject.onNext((self.lastContentOffset-scrollView.contentOffset.y, false))
        }
        
        let cellRect = tableView.rectForRow(at: IndexPath(row: data.count-1, section: 0))
        let completelyVisible = tableView.bounds.contains(cellRect)
        if lastCellVisible != completelyVisible {
            lastCellVisible = completelyVisible
            self.bottomGradientUpdateSubject.onNext(lastCellVisible)
        }
    }
}

