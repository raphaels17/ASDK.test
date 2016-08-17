//
//  PokemonsDataSource.swift
//  ASDK.test
//
//  Created by Raphael Sacle on 8/16/16.
//  Copyright © 2016 Raphael Sacle. All rights reserved.
//


import UIKit
import AsyncDisplayKit

class PokemonsDataSource: NSObject, ASCollectionDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PokemonsDataManager.sharedManager.pokemons.count
    }
    
    func collectionView(collectionView: ASCollectionView, nodeForItemAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        let pokemon = pokemonAtIndex(indexPath)
        return PokemonCollectionCellNode(pokemon: pokemon)
        
    }
    func pokemonAtIndex(indexPath: NSIndexPath) -> Pokemon{
        let pokemons = PokemonsDataManager.sharedManager.pokemons
        return pokemons[indexPath.row]
    }


}
