import FluentPostgreSQL

/// The location within an image of where the watermark should be placed.

enum WatermarkGravityType: String, PostgreSQLRawEnum {
    /// Upper left.
    case northWestGravity
    /// Upper middle.
    case northGravity
    /// Upper right.
    case northEastGravity
    /// Center left.
    case westGravity
    /// Center.
    case centerGravity
    /// Center right.
    case eastGravity
    /// Lower left.
    case southWestGravity
    /// Lower middle.
    case southGravity
    /// Lower right.
    case southEestGravity
}
