import Schemata
import Foundation
import struct DrumKit.Time

extension Time: Schemata.ModelValue {
	public static let value = String.value.bimap(
		decode: { string in
			let offsetString = String(string.suffix(3))
			let offset = try! Int(offsetString, format: .number)
			let zone = TimeZone(secondsFromGMT: offset * 3600)!

			return Time(
				offset: try! Date(string, strategy: formatStyle(for: zone).parseStrategy).timeIntervalSince1970,
				zone: zone
			)
		},
		encode: {
			String(Date(timeIntervalSince1970: $0.offset).formatted(formatStyle(for: $0.zone)).dropLast(2))
		}
	)

	// MARK: Hashable
	public func hash(into hasher: inout Hasher) {
		hasher.combine(offset)
		hasher.combine(zone)
	}
}

// MARK: -
private extension Time {
	static func formatStyle(for timeZone: TimeZone = .init(secondsFromGMT: 0)!) -> Date.VerbatimFormatStyle {
		Date.VerbatimFormatStyle(
			format: "\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))",
			timeZone: timeZone,
			calendar: .current
		)
	}
}
