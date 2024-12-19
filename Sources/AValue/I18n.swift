import Foundation

/// 支持以下语言：
/// de, en, es, fr, it, ja, ko, pt, ru, th, zh-Hans, zh-Hant
enum I18n {
    static let headwind = NSLocalizedString("Headwind", bundle: .module, comment: "The aviation commonly used word 'Headwind'")
    static let crosswind = NSLocalizedString("Crosswind", bundle: .module, comment: "The aviation commonly used word 'Crosswind'")
    static let tailwind = NSLocalizedString("Tailwind", bundle: .module, comment: "The aviation commonly used word 'Tailwind'")
    static let totalWind = NSLocalizedString("Total Wind", bundle: .module, comment: "The aviation commonly used phrase 'Total Wind'. The phrase is used to describe the amount of total wind limit of an aircraft")
    static let limitFactor = NSLocalizedString("Limit Factor", bundle: .module, comment: "Which one of 'Headwind', 'Crosswind', 'Tailwind', 'Total Wind' limits the max wind. The phrase is used to describe the reason where the max wind comes from.")
    static let withinLimit = NSLocalizedString("Within Limit", bundle: .module, comment: "The wind is within the given ground wind limit.")
    static let rwyHDG = NSLocalizedString("Runway HDG", bundle: .module, comment: "The aviation commonly used word 'runway heading'")
    static let windSpeedLimit = NSLocalizedString("Wind speed limit", bundle: .module, comment: "The aviation commonly used phrase 'Wind speed limit'")
    static let maxWindInAllDirections = NSLocalizedString("Max wind in all directions", bundle: .module, comment: "The aviation commonly used phrase 'Max Wind in All Directions'")
    static let coordinates = NSLocalizedString("Coordinates", bundle: .module, comment: "Referring to latitude and longitude of a position.")
    static let latitude = NSLocalizedString("Latitude", bundle: .module, comment: "Latitude of a position.")
    static let longitude = NSLocalizedString("Longitude", bundle: .module, comment: "Longitude of a position.")
    static let map = NSLocalizedString("Map", bundle: .module, comment: "The map that shows geographical locations.")
}
