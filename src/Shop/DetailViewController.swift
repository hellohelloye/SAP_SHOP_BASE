//
//  DetailViewController.swift
//  Shop
//
//  Created by Ye, Yukui (external - Service) on 9/8/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit
import SAPCommon
import SAPOData
import SAPFiori

class DetailViewController: UIViewController {
    
    let logger = Logger.shared(named: "DetailViewController")
    @IBOutlet weak var productView: ProductDetailView!
    
    var productID: String?
    
    fileprivate var product: Product? {
        didSet {
            productView.product = product
            navigationController?.title = product?.name
            productView.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        loadProductDetails()
    }
    /// Load the product details including reviews and images.
    func loadProductDetails() {
        
        if let productID = productID {
            
            // create a query for products matching the given id
            // (which will return only one product)
            var query = DataQuery().withKey(Product.key(id: productID))
            
            // include all associated images in the result
            query = query.expand(Product.images)
            
            // include associated reviews in the result and sort them by the helpful count in descending order,
            // then limit to 3 entries (= top 3 helpful reviews)
            query = query.expand(Product.reviews, withQuery: DataQuery().orderBy(Review.helpfulCount, .descending).top(3))
            
            let loadingIndicator = FUIModalLoadingIndicator.show(inView: view)
            Shop.shared.oDataService?.product(query: query) { products, error in
                
                loadingIndicator.dismiss()
                
                guard error == nil else {
                    self.logger.warn("Error while loading product details", error: error)
                    self.product = nil
                    return
                }
                
                self.product = products?.first
            }
        }
        
        NotificationCenter.default.post(name: Shop.shoppingCartDidUpdateNotification, object: nil)
    }
}

extension DetailViewController: ProductDetailViewDelegate {
    
    func didSelectAddToCart(_ button: FUIButton) {
        
    }
    
    func didSelectReview(_ review: Review) {
        
    }
    
    func didSelectShowAllReviews(_ button: FUIButton) {
        
    }
    
    func didSelectWriteReview(_ button: FUIButton) {
        
    }   
}
