//
//  ViewController.swift
//  ASDK.test
//
//  Created by Raphael Sacle on 8/16/16.
//  Copyright © 2016 Raphael Sacle. All rights reserved.
//


import UIKit
import AsyncDisplayKit


class ViewController: UIViewController, ASCollectionDelegate {
    
    private var searches = [Pokemon]()
    var pokemonsDataManager = PokemonsDataManager()
    let pokemonLoadSize:Int = 5
    var weNeedMoreContent = false
    var collectionNode: ASCollectionNode!
    var pokemonsDataSource = PokemonsDataSource()
    
    //MARK: - override viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionNode()

    }

    func scrollToTop() {
        if(collectionNode?.children()?.count > 0){
            collectionNode?.view.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: .Top, animated: true)
        }
    }
    
    //MARK: - Collection Node
        func configureCollectionNode() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        let frame = view.frame
        collectionNode = ASCollectionNode(frame: frame, collectionViewLayout: layout)
        collectionNode.view.alwaysBounceVertical = true
        collectionNode.view.scrollsToTop = true
        collectionNode.view.asyncDataSource = pokemonsDataSource
        collectionNode.view.asyncDelegate = self
        view.addSubnode(collectionNode)
        initCollection()
        
    }
    //MARK: - CollectionNode Delegate
    func shouldBatchFetchForCollectionView(collectionView: ASCollectionView) -> Bool {
        if (weNeedMoreContent) {
            return true
        }
        return false
    }
    
    func collectionView(collectionView: ASCollectionView, willBeginBatchFetchWithContext context: ASBatchContext) {
        // Fetch data most of the time asynchronoulsy from an API or local database
        self.weNeedMoreContent = false
        pokemonsDataManager.params["startIndex"] = self.searches.count
        pokemonsDataManager.params["endIndex"] = (pokemonsDataManager.params["startIndex"]!.integerValue) + pokemonLoadSize - 1
        self.searches = pokemonsDataManager.pokemons
        pokemonsDataManager.addPokemons(){
            (result: [Pokemon]?, error: NSError!) -> Void in
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    debugPrint("why is this called twice")
                    PokemonsDataManager.sharedManager.pokemons = self.pokemonsDataManager.pokemons
                    // insert data or relaod last index
                    self.collectionNode.reloadData()
                    self.weNeedMoreContent = true
                }
                context.completeBatchFetching(true)
            }
        }
    }
    
    func initCollection(){
        RunOnMainThread { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.weNeedMoreContent = true
            strongSelf.shouldBatchFetchForCollectionView(strongSelf.collectionNode.view)
        }
    }

    
    
}

extension UIViewController {
    func RunOnMainThread(closure : () -> ()) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            closure()
        }
    }
    
}


