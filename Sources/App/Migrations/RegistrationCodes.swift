import Vapor
import FluentPostgreSQL

/// A `Migration` that populates the `RegistrationCode` database from a `registration-codes.txt`
/// file located at the root level of the project.

struct RegistrationCodes: Migration {
        typealias Database = PostgreSQLDatabase
    
    /// Required by `Migration` protocol. Reads either a test or production text file at the
    /// root project level, converts the lines into elements of an array, then iterates over
    /// them to create new `RegistrationCode` models.
    ///
    /// - Parameter conn: A connection to the database, provided automatically.
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        // get file containing registration codes
        let codesFile: String
        // Environment.detect() can throw, so wrap it all in do/catch
        do {
            // use static simple set of codes if just testing
            if (try Environment.detect().isRelease) {
                codesFile = "registration-codes.txt"
            } else {
                codesFile = "test-registration-codes.txt"
            }
            let directoryConfig = DirectoryConfig.detect()
            let codesPath = directoryConfig.workDir.appending(codesFile)
            // read file as string
            guard let data = FileManager.default.contents(atPath: codesPath),
                let dataString = String(bytes: data, encoding: .utf8) else {
                    fatalError("Could not read registration codes file.")
            }
            // normalize contents
            let normalizedString = dataString.lowercased().replacingOccurrences(of: " ", with: "")
            // transform to array
            let codesArray = normalizedString.components(separatedBy: .newlines)
            
            // populate the RegistrationCodes database
            var savedCodes = [Future<RegistrationCode>]()
            for code in codesArray {
                // stray newlines make empty elements
                guard !code.isEmpty else {
                    continue
                }
                let registrationCode = RegistrationCode(code: code)
                savedCodes.append(registrationCode.save(on: conn))
            }
            // resolve the futures and return Void
            return savedCodes.flatten(on: conn).transform(to: ())
        
        } catch let error {
            fatalError("Environment.detect() failed! error: \(error)")
        }
    }
    
    /// Required by`Migration` protocol, but these are static so no point removing them,
    /// just return a pre-completed `Future`.
    static func revert(on connection: PostgreSQLConnection) -> Future<Void> {
        return Future.done(on: connection)
    }
}
