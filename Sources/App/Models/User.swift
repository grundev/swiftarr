import Foundation
import Vapor
import FluentPostgreSQL
import Authentication

/// All accounts are of class `User`.
///
/// The terms "account" and "sub-account" used throughout this documentatiion are all
/// instances of User. The terms "primary account", "parent account" and "master account"
/// are used interchangeably to refer to any account that is not a sub-account.
///
/// A primary account holds the access level, verification token and recovery key, and all
/// sub-accounts (if any) inherit these three credentials.
///
/// `.id` and `.parentID` are provisioned automatically, by the model protocols and
/// `UsersController` account creation handlers respectively. `.createdAt`, `.updatedAt` and
/// `.deletedAt` are all maintained automatically by the model protocols and should never be
///  otherwise modified.

final class User: Codable {
    // MARK: Properties
    
    /// The user's ID, provisioned automatically.
    var id: UUID?
    
    /// The user's publicly viewable username.
    var username: String
    
    /// The user's password, encrypted to BCrypt hash value.
    var password: String
    
    /// The user's recovery key, encrypted to BCrypt hash value.
    var recoveryKey: String
    
    /// The registration code (or other identifier) used to activate the user
    /// for full read-write access.
    var verification: String?
    
    /// If a sub-account, the ID of the User to which this user is associated,
    /// provisioned by `UsersController` handlers during creation.
    var parentID: UUID?
    
    /// The user's `UserAccessLevel`, set to `.unverified` at time of creation,
    /// or to the parent's access level if a sub-account.
    var accessLevel: UserAccessLevel
    
    /// Whether the user prefers to have posted images watermarked by default.
    var prefersWatermark: Bool
    
    /// Optional text to use for a default watermark.
    var watermarkText: String?
    
    /// The gravity to use for a default watermark.
    var watermarkGravity: WatermarkGravityType
    
    /// Number of successive failed attempts at password recovery.
    var recoveryAttempts: Int
    
    /// Cumulative number of reports submitted on user's posts.
    var reports: Int
    
    /// Timestamp of the model's creation, set automatically.
    var createdAt: Date?
    
    /// Timestamp of the model's last update, set automatically.
    var updatedAt: Date?
    
    /// Timestamp of the model's soft-deletion, set automatically.
    var deletedAt: Date?
    
    /// Timestamp of the child UserProfile's last update.
    var profileUpdatedAt: Date
    
    // MARK: Initialization
    
    /// Initializes a new User.
    ///
    /// - Parameters:
    ///   - username: The user's username, unadorned (e.g. "grundoon", not "@grundoon").
    ///   - password: A `BCrypt` hash of the user's password. Please **never** store actual
    ///     passwords.
    ///   - recoveryKey: A `BCrypt` hash of the user's recovery key. Please **never** store
    ///     the actual key.
    ///   - verification: A token of known identity, such as a provided code or a verified email
    ///     address. `nil` if not yet verified.
    ///   - parentID: If a sub-account, the `id` of the master acount, otherwise `nil`.
    ///   - accessLevel: The user's access level (see `UserAccessLevel`).
    ///   - prefersWatermark: Whether the user prefars images to be watermarked by default.
    ///   - watermarkText: The text to use for a default watermark.
    ///   - watermarkGravity: The gravity to use for a default watermark.
    ///   - recoveryAttempts: The number of successive failed attempts at password recovery,
    ///     initially 0.
    ///   - reports: The total number of reports made on the user's posts, initially 0.
    ///   - profileUpdatedAt: The timestamp of the associated profile's last update, initially
    ///     epoch.
    
    init(
        username: String,
        password: String,
        recoveryKey: String,
        verification: String? = nil,
        parentID: UUID? = nil,
        accessLevel: UserAccessLevel,
        prefersWatermark: Bool = false,
        watermarkText: String? = nil,
        watermarkGravity: WatermarkGravityType = .southeastGravity,
        recoveryAttempts: Int = 0,
        reports: Int = 0,
        profileUpdatedAt: Date = Date(timeIntervalSince1970: 0)
    ) {
        self.username = username
        self.password = password
        self.recoveryKey = recoveryKey
        self.verification = verification
        self.parentID = parentID
        self.accessLevel = accessLevel
        self.prefersWatermark = prefersWatermark
        self.watermarkText = watermarkText
        self.watermarkGravity = watermarkGravity
        self.recoveryAttempts = recoveryAttempts
        self.reports = reports
        self.profileUpdatedAt = profileUpdatedAt
    }
}
