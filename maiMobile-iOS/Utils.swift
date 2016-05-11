//
//  GnrPinImage.swift
//  maiMobile-iOS
//
//  Created by Gil Lopes on 29/04/16.
//  Copyright © 2016 WATERDOG mobile. All rights reserved.
//

import UIKit

extension UIImage {
    
    enum HierarchyType: String {
        case CentroDeCooperacaoPolicialAduaneira = "CENTRO DE COOPERA«√O POLICIAL E ADUANEIRA"
        case ComandoTerritorial = "COMANDO TERRITORIAL"
        case DestacamentoDeIntervencao = "DESTACAMENTO DE INTERVEN«√O"
        case DestacamentoDeTransito = "DESTACAMENTO DE TR¬NSITO"
        case DestacamentoTerritorial = "DESTACAMENTO TERRITORIAL"
        case PostoDeTransito = "POSTO DE TR¬NSITO"
        case PostoFiscal = "POSTO FISCAL"
        case PostoTerritorial = "POSTO TERRITORIAL"
        case SubdestacamentoTerritorial = "SUBDESTACAMENTO TERRITORIAL"
        
    }
    
    class func setImageToAnnotation(hierarchyType: HierarchyType.RawValue) -> UIImage {
        var image = UIImage()
        
        switch hierarchyType {
        case HierarchyType.CentroDeCooperacaoPolicialAduaneira.rawValue: image = UIImage(named: "gnrBlack")!
        case HierarchyType.ComandoTerritorial.rawValue: image = UIImage(named: "gnrBlue")!
        case HierarchyType.DestacamentoDeIntervencao.rawValue: image = UIImage(named: "gnrBlueGreen")!
        case HierarchyType.DestacamentoDeTransito.rawValue: image = UIImage(named: "gnrGreen")!
        case HierarchyType.DestacamentoTerritorial.rawValue: image = UIImage(named: "gnrGrey")!
        case HierarchyType.PostoDeTransito.rawValue: image = UIImage(named: "gnrOrange")!
        case HierarchyType.PostoFiscal.rawValue: image = UIImage(named: "gnrPurple")!
        case HierarchyType.PostoTerritorial.rawValue: image = UIImage(named: "gnrRed")!
        case HierarchyType.SubdestacamentoTerritorial.rawValue: image = UIImage(named: "gnrYellow")!
        default:
            break
        }
        
        return image
    }
  
    
}

extension UIColor {
    
    class func bananaColor() -> UIColor {
        return UIColor(red:0.98, green:0.86, blue:0.18, alpha:1.00)
    }
}