import Foundation

/// 支持以下语言：
/// de, en, es, fr, it, ja, ko, pt, ru, th, zh-Hans, zh-Hant
enum I18n {
    static let headwind = NSLocalizedString("headwind", bundle: .module, comment: "The aviation commonly used word 'Headwind'")
    static let crosswind = NSLocalizedString("crosswind", bundle: .module, comment: "The aviation commonly used word 'Crosswind'")
    static let tailwind = NSLocalizedString("tailwind", bundle: .module, comment: "The aviation commonly used word 'Tailwind'")
    static let totalWind = NSLocalizedString("total_wind", bundle: .module, comment: "The aviation commonly used phrase 'Total Wind'. The phrase is used to describe the amount of total wind limit of an aircraft")
    static let limitFactor = NSLocalizedString("limit_factor", bundle: .module, comment: "Which one of 'Headwind', 'Crosswind', 'Tailwind', 'Total Wind' limits the max wind. The phrase is used to describe the reason where the max wind comes from.")
    static let withinLimit = NSLocalizedString("within_limit", bundle: .module, comment: "The wind is within the given ground wind limit.")
    static let rwyHDG = NSLocalizedString("runway_heading", bundle: .module, comment: "The aviation commonly used word 'runway heading'")
    static let windSpeedLimit = NSLocalizedString("wind_speed_limit", bundle: .module, comment: "The aviation commonly used phrase 'Wind speed limit'")
    static let maxWindInAllDirections = NSLocalizedString("max_wind_in_all_directions", bundle: .module, comment: "The aviation commonly used phrase 'Max Wind in All Directions'")
    static let coordinates = NSLocalizedString("coordinates", bundle: .module, comment: "Referring to latitude and longitude of a position.")
    static let latitude = NSLocalizedString("latitude", bundle: .module, comment: "Latitude of a position.")
    static let longitude = NSLocalizedString("longitude", bundle: .module, comment: "Longitude of a position.")
    static let map = NSLocalizedString("map", bundle: .module, comment: "The map that shows geographical locations.")
    
    static let vectorLength = NSLocalizedString("vector_length", bundle: .module, comment: "The measurement of a vector")
    static let angle = NSLocalizedString("angle", bundle: .module, comment: "The angle between a vector and the X-axis in mathematics")
    static let azimuth = NSLocalizedString("azimuth", bundle: .module, comment: "The angle measured clockwise from the north direction in aviation")
    static let bearing = NSLocalizedString("bearing", bundle: .module, comment: "The angle measured clockwise from the north direction in aviation")
    
    static let timeZone = NSLocalizedString("time_zone", bundle: .module, comment: "The time zone of a specific location.")
    
    static let months = NSLocalizedString("months", bundle: .module, comment: "The months used to describe a property <DateComponents>.")
    
    static let windDirection = NSLocalizedString("wind_direction", bundle: .module, comment: "The direction from which the wind is blowing.")
    static let windSpeed = NSLocalizedString("wind_speed", bundle: .module, comment: "The speed of the wind.")
    
    static func name(for valueType: AValueType) -> String {
        NSLocalizedString("\(valueType).name", bundle: .module, comment: "The name for value type \(valueType) which is as short as possible.")
    }
    
    static func introduction(for valueType: AValueType) -> String {
        NSLocalizedString("\(valueType).introduction", bundle: .module, comment: "The introduction to describe \(valueType) value type which is as detailed as possible.")
    }
}
