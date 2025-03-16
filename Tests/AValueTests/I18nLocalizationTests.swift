@testable import AValue
import XCTest

class I18nLocalizationTests: XCTestCase {
    // 支持的本地化标识符
    let supportedLocalizations = ["de", "en", "es", "fr", "it", "ja", "ko", "pt", "ru", "th", "zh-Hans", "zh-Hant"]

    // I18n中的静态键
    let staticKeys = [
        "headwind",
        "crosswind",
        "tailwind",
        "total_wind",
        "limit_factor",
        "within_limit",
        "runway_heading",
        "wind_speed_limit",
        "max_wind_in_all_directions",
        "coordinates",
        "latitude",
        "longitude",
        "map",
        "vector_length",
        "angle",
        "azimuth",
        "bearing",
        "time_zone",
        "months",
        "wind_direction",
        "wind_speed"
    ]

    // 动态生成的键（AValueType）
    var dynamicKeys: [String] {
        AValueType.allCases.flatMap { type in
            ["\(type.rawValue).name", "\(type.rawValue).introduction"]
        }
    }

    // 所有需要测试的键
    var allKeys: [String] {
        staticKeys + dynamicKeys
    }

    func testAllLocalizedStringsHaveTranslations() {
        // 遍历每个支持的语言
        for locale in supportedLocalizations {
            guard let bundle = bundleForLocale(locale) else {
                XCTFail("无法加载\(locale)的Bundle")
                continue
            }

            // 检查每个键
            for key in allKeys {
                let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
                XCTAssertFalse(localizedString.isEmpty, "在\(locale)中缺少对键'\(key)'的翻译")
            }
        }
    }

    private func bundleForLocale(_ locale: String) -> Bundle? {
        // 假设本地化文件在模块的主Bundle中
        guard let path = Bundle.module.path(forResource: locale, ofType: "lproj"),
              let bundle = Bundle(path: path)
        else {
            return nil
        }
        return bundle
    }
}
