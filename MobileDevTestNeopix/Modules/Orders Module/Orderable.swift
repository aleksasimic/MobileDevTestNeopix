protocol Orderable {
    func showOrderDetails(withOrderId id: Int, distributorName: String, distributorLogoUrl: String)
    func closeOrderDetails()
    func showVenueInfo(forVenue venue: Venue)
    func closeVenueInfo()
    func showCancelDeclineOrder()
    func cancelDeclineOrder()
    func declineOrder()
}
