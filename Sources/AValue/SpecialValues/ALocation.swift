public struct ALocation: Codable, Sendable, Hashable {
    var longitude: Double
    var latitude: Double
    var name: String

    init(_ latitude: Double, _ longitude: Double, name: String) {
        self.longitude = longitude
        self.latitude = latitude
        self.name = name
    }
}

extension [ALocation] {
    static let examples = [
        ALocation(37.7749, -122.4194, name: "San Francisco, USA"),
        ALocation(51.5074, -0.1278, name: "London, UK"),
        ALocation(35.6895, 139.6917, name: "Tokyo, Japan"),
        ALocation(48.8566, 2.3522, name: "Paris, France"),
        ALocation(40.7128, -74.0060, name: "New York, USA"),
        ALocation(-33.8688, 151.2093, name: "Sydney, Australia"),
        ALocation(55.7558, 37.6176, name: "Moscow, Russia"),
        ALocation(39.9042, 116.4074, name: "Beijing, China"),
        ALocation(28.6139, 77.2090, name: "New Delhi, India"),
        ALocation(-22.9068, -43.1729, name: "Rio de Janeiro, Brazil"),
        ALocation(41.9028, 12.4964, name: "Rome, Italy"),
        ALocation(1.3521, 103.8198, name: "Singapore"),
        ALocation(30.0444, 31.2357, name: "Cairo, Egypt"),
        ALocation(19.4326, -99.1332, name: "Mexico City, Mexico"),
        ALocation(45.4642, 9.1900, name: "Milan, Italy"),
    ]
}
