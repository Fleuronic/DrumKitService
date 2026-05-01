import Schemata
import Foundation
import struct DrumKit.Time

extension Time: Schemata.ModelValue {
	public static let value = String.value.bimap(
		decode: { string in
			let parts = string.split(separator: ":")
			let hours = Int(parts[0])!
			let minutes = Int(parts[1])!
			let seconds = Int(parts[2].prefix(2))!
			let offsetString = String(string.suffix(3))
			let offset = try! Int(offsetString, format: .number)
			let zone = TimeZone(secondsFromGMT: offset * 3600)!

			return Time(
				offset: TimeInterval(hours * 3600 + minutes * 60 + seconds - zone.secondsFromGMT()),
				zone: zone
			)
		},
		encode: {
			let localSeconds = Int($0.offset) + $0.zone.secondsFromGMT()
			let hours = localSeconds / 3600
			let minutes = (localSeconds % 3600) / 60
			let seconds = localSeconds % 60
			let zoneHours = $0.zone.secondsFromGMT() / 3600
			return String(format: "%02d:%02d:%02d%+03d", hours, minutes, seconds, zoneHours)
		}
	)

	// MARK: Hashable
	public func hash(into hasher: inout Hasher) {
		hasher.combine(offset)
		hasher.combine(zone)
	}
}
