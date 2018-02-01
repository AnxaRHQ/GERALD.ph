//
//  ContentUtil.swift
//  geraldph
//
//  Created by Elaine Reyes on 2/1/18.
//  Copyright © 2018 HAPILABS LIMITED. All rights reserved.
//

import UIKit

class ContentUtil: NSObject
{
    // MARK: Shared Instance
    
    static let sharedInstance : ContentUtil =
    {
        let instance = ContentUtil()
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init()
    {
        super.init()
    }
    
    // MARK: - Menu Contents
    
    func mainMenuContentsArray() -> [String]
    {
        return ["Home",
                "Bakery",
                "Meat",
                "Deli",
                "Seafood",
                "Fruit&Veg",
                "Pasta",
                "Wine",
                "Cheese",
                "Ice Cream",
                "Asian",
                "Healthy Eating",
                "Gluten-Free"]
    }
    
    func bakeryContentsArray() -> [String]
    {
        return ["Bread",
                "Pastries",
                "Macarons",
                "Daily Bakery Boxes",
                "Frozen Dough"]
    }
    
    func meatContentsArray() -> [String]
    {
        return ["Beef",
                "Poultry",
                "Lamb",
                "Pork",
                "French Duck",
                "French Guinea Fowl",
                "Veal",
                "Free-Range Pork",
                "Free-Range Chicken"]
    }
    
    func beefContentsArray() -> [String]
    {
        return ["Certified Angus Beef",
                "USDA Choice Beef",
                "Australian Grass-Fed Beef",
                "Pinoy Grass-Fed Beef"]
    }
    
    func deliContentsArray() -> [String]
    {
        return ["Ham & Cold Cuts",
                "Butcher's Specials",
                "Pâtés",
                "Smoked Sausages",
                "Barbecue Sausages",
                "Dairy",
                "Appetizers",
                "Oils & Vinegars",
                "Spices & Seasonings",
                "Grocery"]
    }
    
    func fruitsAndVegContentsArray() -> [String]
    {
        return ["Potatoes & Fries",
                "Organic Vegetables",
                "Fruit Purées",
                "Fruits",
                "Vegetables",
                "Aromatic Herbs"]
    }
    
    func pastaContentsArray() -> [String]
    {
        return ["Vegan Pasta",
                "Fresh Pasta",
                "Whole Wheat Pasta",
                "Gluten-Free Pasta",
                "Barilla Pasta"]
    }
    
    func wineContentsArray() -> [String]
    {
        return ["Red Wine",
                "White Wine",
                "Rosé Wine",
                "Sparkling",
                "Sweet Wine",
                "Liquor"]
    }
    
    func redWineContentsArray() -> [String]
    {
        return ["France",
                "Italy",
                "Spain",
                "Argentina",
                "Chile",
                "New Zealand"]
    }
    
    func whiteWineContentsArray() -> [String]
    {
        return ["France",
                "Italy",
                "Argentina",
                "Chile",
                "New Zealand",
                "South Africa"]
    }
    
    func roseWineContentsArray() -> [String]
    {
        return ["France",
                "Chile",
                "New Zealand"]
    }
    
    func sparklingWineContentsArray() -> [String]
    {
        return ["France",
                "Italy"]
    }
    
    func cheeseContentsArray() -> [String]
    {
        return ["Imported Cheeses",
                "Vegan Cheeses"]
    }
    
    func iceCreamContentsArray() -> [String]
    {
        return ["New Zealand Natural",
                "Cocolatto",
                "ADAM'S Ice Cream",
                "Fog City Ice Cream"]
    }
    
    func healthyEatingContentsArray() -> [String]
    {
        return ["Healthy Snacks",
                "Healthy Spreads",
                "Natural Sweeteners",
                "Vegan Cheeses",
                "Organic Ready Meals",
                "Organic Soups & Sauces",
                "Free-Range",
                "Healthy Food Swaps",
                "Organic Rice",
                "Dairy Free",
                "Diabetic Friendly"]
    }
    
    func glutenFreeContentsArray() -> [String]
    {
        return ["Gluten-Free Ready Meals",
                "Gluten-Free Bakery",
                "Gluten-Free Mixes",
                "Gluten-Free Ice Cream",
                "Gluten-Free Pasta"]
    }
    
    // MARK: - Menu Links
    
    func mainMenuLinksArray() -> [String]
    {
        return [landingPageLiveURL,
                landingPageLiveURL.appending("bakery"),
                landingPageLiveURL.appending("meat"),
                landingPageLiveURL.appending("deli"),
                landingPageLiveURL.appending("seafood"),
                landingPageLiveURL.appending("fruits-vegetables"),
                landingPageLiveURL.appending("pasta"),
                landingPageLiveURL.appending("wine"),
                landingPageLiveURL.appending("cheese-dairy"),
                landingPageLiveURL.appending("ice-cream"),
                landingPageLiveURL.appending("asian-food-delivery"),
                landingPageLiveURL.appending("healthy-eating"),
                landingPageLiveURL.appending("gluten-free")]
    }
    
    func bakeryLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("bread"),
                landingPageLiveURL.appending("pastries"),
                landingPageLiveURL.appending("macarons"),
                landingPageLiveURL.appending("daily-bakery-box"),
                landingPageLiveURL.appending("frozen-dough")]
    }
    
    func meatLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("beef"),
                landingPageLiveURL.appending("poultry"),
                landingPageLiveURL.appending("lamb"),
                landingPageLiveURL.appending("pork"),
                landingPageLiveURL.appending("duck"),
                landingPageLiveURL.appending("french-guinea-fowl"),
                landingPageLiveURL.appending("free-range-pork"),
                landingPageLiveURL.appending("free-range-chicken")]
    }
    
    func beefLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("certified-angus-beef"),
                landingPageLiveURL.appending("usda-choice-beef"),
                landingPageLiveURL.appending("australian-grass-fed-beef"),
                landingPageLiveURL.appending("grass-fed-beef")]
    }
    
    func deliLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("ham-cold-cuts"),
                landingPageLiveURL.appending("butchers-specials"),
                landingPageLiveURL.appending("pates"),
                landingPageLiveURL.appending("smoked-sausages"),
                landingPageLiveURL.appending("barbecue-sausages"),
                landingPageLiveURL.appending("dairy"),
                landingPageLiveURL.appending("appetizers"),
                landingPageLiveURL.appending("oils-and-vinegars"),
                landingPageLiveURL.appending("spices-and-seasonings"),
                landingPageLiveURL.appending("grocery")]
    }
    
    func fruitsAndVegLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("potatoes-fries"),
                landingPageLiveURL.appending("organic-vegetables"),
                landingPageLiveURL.appending("fruit-purees"),
                landingPageLiveURL.appending("fruits"),
                landingPageLiveURL.appending("vegetables"),
                landingPageLiveURL.appending("aromatic-herbs")]
    }
    
    func pastaLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("healthy-vegan-pasta"),
                landingPageLiveURL.appending("fresh-pasta"),
                landingPageLiveURL.appending("whole-wheat-pasta"),
                landingPageLiveURL.appending("gluten-free-pasta"),
                landingPageLiveURL.appending("barilla-pasta")]
    }
    
    func wineLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("red-wine"),
                landingPageLiveURL.appending("white-wine"),
                landingPageLiveURL.appending("rose-wine"),
                landingPageLiveURL.appending("sparkling-wine"),
                landingPageLiveURL.appending("sweet-wine"),
                landingPageLiveURL.appending("liquor")]
    }
    
    func redWineLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("french-wine"),
                landingPageLiveURL.appending("italian-wine"),
                landingPageLiveURL.appending("spanish-wine"),
                landingPageLiveURL.appending("argentina-wine"),
                landingPageLiveURL.appending("chilean-wine"),
                landingPageLiveURL.appending("new-zealand-wine")]
    }
    
    func whiteWineLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("french-white-wines"),
                landingPageLiveURL.appending("italian-white-wines"),
                landingPageLiveURL.appending("argentinian-white-wines"),
                landingPageLiveURL.appending("chilean-white-wines"),
                landingPageLiveURL.appending("new-zealand-white-wines"),
                landingPageLiveURL.appending("south-african-wines")]
    }
    
    func roseWineLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("french-rose-wines"),
                landingPageLiveURL.appending("chilean-rose-wines"),
                landingPageLiveURL.appending("new-zealand-rose-wines")]
    }
    
    func sparklingWineLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("france-sparkling-wine"),
                landingPageLiveURL.appending("italy-3")]
    }
    
    func cheeseLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("imported-cheeses"),
                landingPageLiveURL.appending("vegan-cheeses")]
    }
    
    func iceCreamLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("new-zealand-natural"),
                landingPageLiveURL.appending("cocolatto-ice-cream"),
                landingPageLiveURL.appending("adams-ice-cream"),
                landingPageLiveURL.appending("fog-city-ice-cream")]
    }
    
    func healthyEatingLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("snacks-healthy-food-delivery"),
                landingPageLiveURL.appending("healthy-spreads"),
                landingPageLiveURL.appending("natural-sweeteners"),
                landingPageLiveURL.appending("vegan-cheeses-healthy-eating"),
                landingPageLiveURL.appending("organic-ready-meals-healthy-food-delivery"),
                landingPageLiveURL.appending("organic-soups-sauces-salsa-healthy-food-delivery"),
                landingPageLiveURL.appending("free-range"),
                landingPageLiveURL.appending("healthy-option-food-substitutes"),
                landingPageLiveURL.appending("organic-rice"),
                landingPageLiveURL.appending("dairy-free"),
                landingPageLiveURL.appending("diabetic-friendly")]
    }
    
    func glutenFreeLinksArray() -> [String]
    {
        return [landingPageLiveURL.appending("gluten-free-ready-meals"),
                landingPageLiveURL.appending("gluten-free-bakery"),
                landingPageLiveURL.appending("gluten-free-mixes"),
                landingPageLiveURL.appending("gluten-free-dairy-free-ice-cream"),
                landingPageLiveURL.appending("gluten-free-pasta-pizza")]
    }
}
