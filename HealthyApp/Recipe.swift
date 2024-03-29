import UIKit
import os.log

class Recipe: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    var instruction: String?
    var isFavorite: Bool
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("recipes")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let instruction = "instruction"
        static let isFavorite = "isFavorite"
    }
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int, instruction: String, isFavorite: Bool) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 2 inclusively
        guard (rating >= 0) && (rating <= 2) else {
            return nil
        }
    
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        self.instruction = instruction
        self.isFavorite = isFavorite;
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(instruction, forKey: PropertyKey.instruction)
        aCoder.encode(isFavorite, forKey: PropertyKey.isFavorite)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Recipe object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let instruction = aDecoder.decodeObject(forKey: PropertyKey.instruction) as? String else {
            os_log("Unable to decode the instruction for a Recipe object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let isFavorite = aDecoder.decodeObject(forKey: PropertyKey.isFavorite) as? Bool else {
            os_log("Unable to decode the isFavorite for a Recipe object.", log: OSLog.default, type: .debug)
            return nil
        }

        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating, instruction: instruction, isFavorite: isFavorite)
    }
    
}
