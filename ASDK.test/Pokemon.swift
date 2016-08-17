//
//  Pokemon.swift
//  ASDK.test
//
//  Created by Raphael Sacle on 8/16/16.
//  Copyright © 2016 Raphael Sacle. All rights reserved.
//


import UIKit
import Alamofire
import AlamofireImage
import AsyncDisplayKit

struct Pokemon{
    let name: String
    let id: Int
    var latitude: Double?
    var longitude: Double?
}

class PokemonsDataManager: NSObject {
    let photoCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )
    static let sharedManager = PokemonsDataManager()
    var pokemons = [Pokemon]()
    internal var params:[String: AnyObject] = [
        "startIndex" : 0,
        "endIndex":4]
    //MARK: - Read Data
    
    
    func addPokemons(completion:(result: [Pokemon], error: NSError!)-> Void) -> Void{
        // 2. Create HTTP request and set request header
        Alamofire.request(.GET, "https://www.tablerig.com/tables/calpaterson/pokemon-with-images")
                 .responseJSON { response in
                let json = JSON(data:response.data!)
                    for (_, subJson) in json["body"] {
                        let name = subJson["pokemon-name"].stringValue
                        let id = subJson["national-pokedex-number"].intValue
                        let pokemon = Pokemon(name: name, id: id,latitude: nil,longitude: nil)
                        self.pokemons.append(pokemon)
                    }
         completion(result: self.pokemons, error: nil)
        }

    }
    
    //MARK: = Image Caching
    
    func cacheImage(image: Image, pokemonId: String) {
        photoCache.addImage(image, withIdentifier: pokemonId)
    }
    
    func cachedImage(pokemonId: String) -> Image? {
        photoCache.imageWithIdentifier(pokemonId)
        return photoCache.imageWithIdentifier(pokemonId)
    }
    
}
//MARK: - Image Downloading
extension PokemonsDataManager: ASImageDownloaderProtocol {
    func downloadImageWithURL(url: NSURL, callbackQueue: dispatch_queue_t?, downloadProgressBlock: ((CGFloat) -> Void)?, completion: ((CGImage?, NSError?) -> Void)?) -> AnyObject? {

        return Alamofire.request(.GET, url).responseImage { (response) -> Void in
            guard let image = response.result.value else {
                let error = response.result.error
                completion?(nil,error)
                return
            }
            self.cacheImage(image, pokemonId: url.absoluteString)
            completion?(image.CGImage, nil)
        }
    }
    
    func cancelImageDownloadForIdentifier(downloadIdentifier: AnyObject?) {
        if let request = downloadIdentifier where request is Request {
            (request as! Request).cancel()
        }
    }
}

extension PokemonsDataManager: ASImageCacheProtocol {
    func fetchCachedImageWithURL(URL: NSURL?, callbackQueue: dispatch_queue_t?, completion: (CGImage?) -> Void) {
        if let url = URL, cachedImage = cachedImage(url.absoluteString) {
            completion(cachedImage.CGImage)
            return
        }
        completion(nil)
    }
}