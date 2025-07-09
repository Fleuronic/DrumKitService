// Copyright © Fleuronic LLC. All rights reserved.

import Schemata
import struct DrumKit.Slot
import struct DrumKit.Feature
import struct DrumKit.Performance
import struct DrumKit.Placement
import struct DrumKit.Division
import struct DrumKit.Corps
import struct DrumKit.Location
import struct DrumKit.State
import struct DrumKit.Country

extension Array: Schemata.AnyModel where Element: Model {
	public static var anySchema: AnySchema {
		.init(schema)
	}
}

extension Array: Schemata.Model where Element: Model {
	public static var schema: Schema<Self> {
		if let type = self as? [Slot.Identified].Type {
			return type.schema as! Schema<Self>
		} else if let type = self as? [Feature.Identified].Type {
			return type.schema as! Schema<Self>
		} else if let type = self as? [Performance.Identified].Type {
			return type.schema as! Schema<Self>
		} else if let type = self as? [Placement.Identified].Type {
			return type.schema as! Schema<Self>
		} else if let type = self as? [Division.Identified].Type {
			return type.schema as! Schema<Self>
		} else if let type = self as? [Corps.Identified].Type {
			return type.schema as! Schema<Self>
		} else if let type = self as? [Location.Identified].Type {
			return type.schema as! Schema<Self>
		} else if let type = self as? [State.Identified].Type {
			return type.schema as! Schema<Self>
		} else if let type = self as? [Country.Identified].Type {
			return type.schema as! Schema<Self>
		}

		fatalError()
	}
}
