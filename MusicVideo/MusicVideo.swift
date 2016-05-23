//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Joanna Kolny-Olesiak on 23.05.16.
//  Copyright © 2016 Joanna Kolny-Olesiak. All rights reserved.
//

import Foundation

class Videos {
    //Data Encapsulation
    
    private var _vName:String
    private var _vRights:String
    private var _vPrice:String
    private var _vImageUrl:String
    private var _vArtist:String
    private var _vVideoUrl:String
    private var _vImid:String
    private var _vGenre:String
    private var _vLinkToiTunes:String
    private var _vReleaseDte:String
    var vImageData:NSData?
    
    //Make a getter
    var vName: String {
        return _vName
    }
    
    var vRights: String {
        return _vRights
    }
    
    var  vPrice: String {
        return _vPrice
    }
    
    var vImageUrl:String {
        return _vImageUrl
    }
    
    var vArtist:String {
        return _vArtist
    }
    
    var vVideoUrl:String {
        return _vVideoUrl
    }
    
    var vImid: String {
        return _vImid
    }
    
    var vGenre:String {
        return _vGenre
    }
    
    var vLinkToiTunes:String {
        return _vLinkToiTunes
    }
    
    var vReleaseDte: String {
        return _vReleaseDte
    }
    
    init(data: JSONDictionary) {
        
        //Video name
        if let name = data["im:name"] as? JSONDictionary, vName = name["label"] as? String {
            self._vName = vName
        } else {
            _vName = ""
        }
        
        //Video Rights
        if let rights = data["rights"] as? JSONDictionary, vRights = rights["label"] as? String {
            self._vRights = vRights
        } else {
            _vRights = ""
        }
        
        // Video Price
        
        if let price = data["im:price"] as? JSONDictionary, vPrice = price["label"] as? String {
            self._vPrice = vPrice
        } else {
            _vPrice = ""
        }
        
        // The Video Image
        if let img = data["im:image"] as? JSONArray, image = img[2] as? JSONDictionary, immage = image["label"] as? String {
            _vImageUrl = immage.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
        } else {
            _vImageUrl = ""
        }
        
        // Artist
        if let  artist = data["im:artist"] as? JSONDictionary, vArtist = artist["label"] as? String {
            self._vArtist = vArtist
        } else {
            _vArtist = ""
        }
        
        // Video Url
        if let video = data["link"] as? JSONArray, vUrl = video[1] as? JSONDictionary, vHref = vUrl["attributes"] as? JSONDictionary, vVideoUrl = vHref["href"] as? String {
            self._vVideoUrl = vVideoUrl
        } else {
            _vVideoUrl = ""
        }
        
        // Im:Id
        if let id = data["id"] as? JSONDictionary, imid = id["attributes"] as? JSONDictionary, vImid = imid["im:id"] as? String {
            self._vImid = vImid
        } else {
            _vImid = ""
        }
        
        // Genre
        if let genre = data["category"] as? JSONDictionary, term = genre["attributes"] as? JSONDictionary, vGenre = term["term"] as? String {
            self._vGenre = vGenre
        } else {
            _vGenre = ""
        }
        
        // Link to iTunes
        if let link = data["id"] as? JSONDictionary, vLinkToiTunes = link["label"] as? String {
            self._vLinkToiTunes = vLinkToiTunes
        } else {
            _vLinkToiTunes = ""
        }
        
        // Release Date
        if let releaseDate = data["im:releaseDate"] as? JSONDictionary, vReleaseDate = releaseDate["attributes"] as? JSONDictionary, vReleaseDte = vReleaseDate["label"] as? String {
            self._vReleaseDte = vReleaseDte
        } else {
            _vReleaseDte = ""
        }
    }
    
}












