struct ALocation: Codable, Sendable, Hashable {
    var longitude: Double
    var latitude: Double
    var name: String
}

extension [ALocation] {
    static let examples =  [
        ALocation(longitude: -122.4194, latitude: 37.7749, name: "San Francisco, USA"),
        ALocation(longitude: -0.1278, latitude: 51.5074, name: "London, UK"),
        ALocation(longitude: 139.6917, latitude: 35.6895, name: "Tokyo, Japan"),
        ALocation(longitude: 2.3522, latitude: 48.8566, name: "Paris, France"),
        ALocation(longitude: -74.0060, latitude: 40.7128, name: "New York, USA"),
        ALocation(longitude: 151.2093, latitude: -33.8688, name: "Sydney, Australia"),
        ALocation(longitude: 37.6176, latitude: 55.7558, name: "Moscow, Russia"),
        ALocation(longitude: 116.4074, latitude: 39.9042, name: "Beijing, China"),
        ALocation(longitude: 77.2090, latitude: 28.6139, name: "New Delhi, India"),
        ALocation(longitude: -43.1729, latitude: -22.9068, name: "Rio de Janeiro, Brazil"),
        ALocation(longitude: 12.4964, latitude: 41.9028, name: "Rome, Italy"),
        ALocation(longitude: 103.8198, latitude: 1.3521, name: "Singapore"),
        ALocation(longitude: 31.2357, latitude: 30.0444, name: "Cairo, Egypt"),
        ALocation(longitude: -99.1332, latitude: 19.4326, name: "Mexico City, Mexico"),
        ALocation(longitude: 9.1900, latitude: 45.4642, name: "Milan, Italy")
    ]
}
