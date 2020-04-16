import RxSwift

class OrderDetailsProductsDataSource: NSObject, UITableViewDataSource {
    private var data: [Product] = []
    private let tableView: UITableView
    private let bag = DisposeBag()
    
    private var distributorLogoUrl: String?
    private var distributorName: String?
    
    init(withTableView tableView: UITableView,
         products: Observable<[Product]>) {
        self.tableView = tableView
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
    }
    
    private func reload(withData data: [Product]) {
        self.data = data
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

