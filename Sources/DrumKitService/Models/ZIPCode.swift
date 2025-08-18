// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import PersistDB
import Catenoid
import Identity
import Foundation
import struct DrumKit.ZIPCode
import struct Catena.IDFields
import protocol Catena.Valued

public extension ZIPCode {
	typealias ID = Identified.ID
	typealias IDFields = Catena.IDFields<Identified>
	typealias Identified = IdentifiedZIPCode
}

// MARK: -
public struct IdentifiedZIPCode: Sendable {
	public let id: ZIPCode.ID
	public let value: ZIPCode
}

// MARK: -
extension ZIPCode.Identified {
	static func predicate(code: String) -> PersistDB.Predicate<Self> {
		\.value.code == code
	}
}

// MARK: -
extension ZIPCode.Identified: Identifiable {
	// MARK: Identifiable
	public typealias RawIdentifier = UUID
}

extension ZIPCode.Identified: Valued {
	// MARK: Valued
	public typealias Value = ZIPCode
}

extension ZIPCode.Identified: PersistDB.Model {
	// MARK: Model
	public enum Path: String, CodingKey {
		case code
	}

	public static let schema = Schema(
		Self.init,
		\.id * .id,
		\.value.code * .code
	)

	public static let schemaName = "zip_codes"

	// MARK: Model
	public static var defaultOrder: [Ordering<Self>] {
		[.init(\.value.code, ascending: true)]
	}
}

// MARK: -
private extension ZIPCode.Identified {
	init(
		id: ZIPCode.ID,
		code: String
	) {
		self.init(
			id: id,
			value: .init(code: code)
		)
	}
}
// MARK: -