@testable import AValue
import XCTest

final class AValueTranslationTest: XCTestCase {
    func testTranslations() throws {
        let languages = ["de", "en", "es", "fr", "it", "ja", "ko", "pt", "ru", "th", "zh-Hans", "zh-Hant"]
        let keys = [
            "headwind", "crosswind", "tailwind", "total_wind", "limit_factor", "within_limit",
            "runway_heading", "wind_speed_limit", "max_wind_in_all_directions", "coordinates",
            "latitude", "longitude", "map", "vector_length", "angle", "azimuth", "bearing",
            "time_zone", "months", "wind_direction", "wind_speed",
        ]

        for language in languages {
            guard let bundlePath = Bundle.module.path(forResource: language, ofType: "lproj"),
                  let bundle = Bundle(path: bundlePath)
            else {
                XCTFail("Missing bundle for language '\(language)'")
                continue
            }

            for key in keys {
                let translation = NSLocalizedString(key, bundle: bundle, comment: "")
                XCTAssertFalse(translation.isEmpty, "Missing translation for key '\(key)' in language '\(language)'")
            }
        }
    }
}
