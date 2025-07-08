// Copyright © Fleuronic LLC. All rights reserved.

import struct DrumKit.Performance
import struct Catena.IDFields
import protocol Catena.Fields

public protocol PerformanceFields: Fields where Model == Performance.Identified {}

// MARK: -
extension IDFields: PerformanceFields where Model == Performance.Identified {}
