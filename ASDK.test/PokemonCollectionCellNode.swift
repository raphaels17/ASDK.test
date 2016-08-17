//
//  PokemonCollectionCellNode.swift
//  ASDK.test
//
//  Created by Raphael Sacle on 8/16/16.
//  Copyright © 2016 Raphael Sacle. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import GoogleMaps

class PokemonCollectionCellNode: ASCellNode {
    var pokemon : Pokemon
    var imageNode = ASNetworkImageNode()
    var backUp : StreetViewNode?
    
    init(pokemon: Pokemon){
       self.pokemon = pokemon
       super.init()
        let manager = PokemonsDataManager.sharedManager
        imageNode = ASNetworkImageNode(cache: manager, downloader: manager)
        imageNode.contentMode = .ScaleAspectFill
        if(pokemon.id%20 > 0){
             imageNode.URL = NSURL(string: "https://s3-eu-west-1.amazonaws.com/calpaterson-pokemon/\(pokemon.id).jpeg")
        }else{
             imageNode.URL = NSURL(string: "https://s3-eu-west-1.amazonaws.com/calpaterson-pokemon/\(pokemon.id).\(pokemon.id)")
        }
        imageNode.delegate = self
        imageNode.clipsToBounds = true
        imageNode.layerBacked = true
        addSubnode(imageNode)
    }
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageLayoutSpec = ASRatioLayoutSpec(ratio: 1, child: imageNode)
        var mainStackLayoutSpec = ASBackgroundLayoutSpec(child: imageLayoutSpec, background: imageLayoutSpec)
        if backUp != nil {
            let backUpLayoutSpec = ASRatioLayoutSpec(ratio: 1, child: backUp!)
            mainStackLayoutSpec = ASBackgroundLayoutSpec(child: backUpLayoutSpec, background: imageLayoutSpec)
        }
        mainStackLayoutSpec.flexGrow = true
        mainStackLayoutSpec.alignSelf = .Stretch
        mainStackLayoutSpec.sizeRange = ASRelativeSizeRange(
            min: ASRelativeSize(
                width: ASRelativeDimension(type: .Points, value: 250),
                height: ASRelativeDimension(type: .Points, value: constrainedSize.max.width * 0.75)
            ),
            max: ASRelativeSize(
                width: ASRelativeDimension(type: .Points, value: constrainedSize.max.width * 0.85),
                height: ASRelativeDimension(type: .Points, value: constrainedSize.max.width * 0.75)
            )
        )
        
        let mainStaticLayoutSpec = ASStaticLayoutSpec(children: [mainStackLayoutSpec])
        return mainStaticLayoutSpec
    }

}
extension PokemonCollectionCellNode: ASNetworkImageNodeDelegate {
    
    func imageNode(imageNode: ASNetworkImageNode, didLoadImage image: UIImage) {

    }
    func imageNode(imageNode: ASNetworkImageNode, didFailWithError error: NSError) {
        let pokemonLocation = generateRandomCoordinates(0,max: 10000)
        self.pokemon.latitude = pokemonLocation.latitude
        pokemon.longitude = pokemonLocation.longitude
        backUp = StreetViewNode(pokemon: pokemon)
        addSubnode(backUp!)
        setNeedsLayout()
    }
    
    // LONGITUDE -180 to + 180
    func generateRandomCoordinates(min: UInt32, max: UInt32)-> CLLocationCoordinate2D {
        //Get the Current Location's longitude and latitude
        let currentLong = 2.352222

        let currentLat = 48.856614
        
        //1 KiloMeter = 0.00900900900901° So, 1 Meter = 0.00900900900901 / 1000
        let meterCord = 0.00900900900901 / 1000
        
        //Generate random Meters between the maximum and minimum Meters
        let randomMeters = UInt(arc4random_uniform(max) + min)
        
        //then Generating Random numbers for different Methods
        let randomPM = arc4random_uniform(6)
        
        //Then we convert the distance in meters to coordinates by Multiplying number of meters with 1 Meter Coordinate
        let metersCordN = meterCord * Double(randomMeters)
        
        //here we generate the last Coordinates
        if randomPM == 0 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
        }else if randomPM == 1 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
        }else if randomPM == 2 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
        }else if randomPM == 3 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
        }else if randomPM == 4 {
            return CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - metersCordN)
        }else {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong)
        }
        
    }
    
   
    
}

class StreetViewNode: ASDisplayNode,GMSPanoramaViewDelegate  {
    var StreetView: GMSPanoramaView
<<<<<<< HEAD
    // we assume the pokemon has a location for the last place it has been seen
=======
    // we assume the pokemon has a location for the last place it has been seen 
>>>>>>> origin/master
    var pokemon:Pokemon?
    
    init(pokemon: Pokemon) {
        debugPrint("this I guess is not great cause use UIkit,how to work around this")
        self.StreetView = GMSPanoramaView.panoramaWithFrame(CGRectMake(0,0,400, 300),nearCoordinate:CLLocationCoordinate2DMake(pokemon.latitude!, pokemon.longitude!))
        super.init(viewBlock: {
            let streetView = GMSPanoramaView.panoramaWithFrame(CGRectZero,nearCoordinate:CLLocationCoordinate2DMake(pokemon.latitude!, pokemon.longitude!))
            streetView.translatesAutoresizingMaskIntoConstraints = false
            return streetView  }, didLoadBlock: nil)
        
        
        self.StreetView.delegate = self
        self.pokemon = pokemon
    }
    
    func panoramaView(view: GMSPanoramaView, didMoveToPanorama panorama: GMSPanorama, nearCoordinate coordinate: CLLocationCoordinate2D) {
        debugPrint("this is bieng capture \(view.panorama?.coordinate.latitude)")
    }
    func panoramaViewDidStartRendering(panoramaView: GMSPanoramaView) {
        
        dispatch_async(dispatch_get_main_queue()) {
            debugPrint("this is not. because google Docs speficy The GMSPanoramaViewDelegate methods will also be called back only on the main thread. How can I work around this?")
        }
        
 
    }
}
