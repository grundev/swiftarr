import FluentPostgreSQL

/// The location within an image of where the watermark should be placed.

enum WatermarkGravityType: String, CaseIterable, PostgreSQLRawEnum {
    /// Upper left.
    case northwestGravity = "northwestGravity"
    /// Upper middle.
    case northGravity = "northGravity"
    /// Upper right.
    case northeastGravity = "northeastGravity"
    /// Center left.
    case westGravity = "westGravity"
    /// Center.
    case centerGravity = "centerGravity"
    /// Center right.
    case eastGravity = "eastGravity"
    /// Lower left.
    case southwestGravity = "southwestGravity"
    /// Lower middle.
    case southGravity = "southGravity"
    /// Lower right.
    case southeastGravity = "southeastGravity"
}
