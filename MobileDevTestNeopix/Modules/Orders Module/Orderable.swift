protocol Orderable {
    func showOrderDetails(withOrderId id: Int, distributorName: String, distributorLogoUrl: String)
    func closeOrderDetails()
}
