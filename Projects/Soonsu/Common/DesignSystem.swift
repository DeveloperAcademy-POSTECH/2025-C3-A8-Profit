//
//  DesignSystem.swift
//  Soonsu
//
//  Created by ellllly on 6/10/25.
//

import SwiftUI

extension Color {
    static let primaryColor700 = Color("Primary700")
    static let primaryColor600 = Color("Primary600")
    static let primaryColor500 = Color("Primary500")
    static let primaryColor400 = Color("Primary400")
    static let primaryColor300 = Color("Primary300")
    static let primaryColor200 = Color("Primary200")
    static let primaryColor100 = Color("Primary100")
    static let primaryColor50 = Color("Primary50")
    
    static let neutralColor700 = Color("Neutral700")
    static let neutralColor600 = Color("Neutral600")
    static let neutralColor500 = Color("Neutral500")
    static let neutralColor400 = Color("Neutral400")
    static let neutralColor300 = Color("Neutral300")
    static let neutralColor200 = Color("Neutral200")
    static let neutralColor100 = Color("Neutral100")
    static let neutralColor50 = Color("Neutral50")
    static let warningColor50 = Color("Warning700")
    
    static let backgroundColorSeleted = Color("Selected700")
    static let backgroundColorEmphasis = Color("Emphasis700")
    static let backgroundColorSubtle = Color("Subtle700")
    
    static let textBodyColor700 = Color("BodyText700")
    static let textBodyColor300 = Color("BodyText300")
    static let textEmphasisColor = Color("EmphasisText700")
    static let textButtonColor = Color("ButtonText700")
}

extension Font {
    static let titlePage = Font.system(size: 24, weight: .bold)
    static let titleSection = Font.system(size:20, weight: .semibold)
    
    static let textBody = Font.system(size: 15, weight: .regular)
    static let textCaption = Font.system(size: 13, weight: .regular)
    static let textSmall = Font.system(size: 9, weight: .regular)
    static let textModalInfo = Font.system(size: 15, weight: .medium)
    static let textEmphasis = Font.system(size: 17, weight: .bold)
    
    static let numberXLarge = Font.system(size: 34, weight: .bold)
    static let numberLarge = Font.system(size: 18, weight: .bold)
    static let numberSmall = Font.system(size: 13, weight: .semibold)
    
    static let buttonLarge = Font.system(size: 17, weight: .bold)
    static let buttonSmall = Font.system(size: 15, weight: .medium)
    
    static let cardTitle = Font.system(size: 15, weight: .medium)
    static let cardSubtitle = Font.system(size: 13, weight: .bold)
    static let cardDescription = Font.system(size: 13, weight: .regular)
    
    static let listLabel = Font.system(size: 15, weight: .semibold)
    static let listValue = Font.system(size: 15, weight: .regular)
    
}
