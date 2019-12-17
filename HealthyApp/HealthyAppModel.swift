import CoreData
import UIKit

class HealthyAppModel {

    static func saveRecipes(recipes: [Recipe]) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        for recipe in recipes {
            let newRecipe = NSEntityDescription.insertNewObject(forEntityName: "Recipes", into: context)
            newRecipe.setValue(recipe.name, forKey: "name")
            if let imageData = recipe.photo?.pngData() {
                newRecipe.setValue(imageData, forKey: "photo")
            }
            newRecipe.setValue(recipe.rating, forKey: "rating")
            newRecipe.setValue(recipe.instruction, forKey: "instruction")
            newRecipe.setValue(recipe.isFavorite, forKey: "isFavorite")
        }
        do {
            try context.save()
            print("Recipes successfully saved.")
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    static func updateRecipes(recipe: Recipe) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Recipes")
        fetchRequest.predicate = NSPredicate(format: "name = %@", recipe.name)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(recipe.name, forKey: "name")
            
            if let imageData = recipe.photo?.pngData() {
                objectUpdate.setValue(imageData, forKey: "photo")
            }

            objectUpdate.setValue(recipe.rating, forKey: "rating")
            objectUpdate.setValue(recipe.instruction, forKey: "instruction")
            objectUpdate.setValue(recipe.isFavorite, forKey: "isFavorite")
            
            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMOC.parent = managedContext
            
            privateMOC.perform {
                do {
                    try managedContext.save()
                }
                catch
                {
                    print(error)
                }
            }
           
        }
        catch
        {
            print(error)
        }
        
    }
    
    static func retrieveSavedRecipes() -> [Recipe]? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        request.returnsObjectsAsFaults = false
        var retrievedRecipes: [Recipe] = []
        do {
            let results = try context.fetch(request)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    guard let name = result.value(forKey: "name") as? String else { return nil }
                    let photo: UIImage?
                    if let imageData = result.value(forKey: "photo") as? NSData {
                        photo = UIImage(data: imageData as Data)!
                    } else {
                        photo = UIImage(named: "defaultPhoto")
                    }
                    guard let rating = result.value(forKey: "rating") as? Int else { return nil }
                    guard let instruction = result.value(forKey: "instruction") as? String else { return nil }
                    guard let isFavorite = result.value(forKey: "isFavorite") as? Bool else { return nil }
                    guard let recipe = Recipe(name: name, photo: photo, rating: rating, instruction: instruction, isFavorite: isFavorite) else { return nil }
                    retrievedRecipes.append(recipe)
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return retrievedRecipes
    }
   
    static func deleteRecipe(recipe: Recipe){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Recipes")
        fetchRequest.predicate = NSPredicate(format: "name = %@", recipe.name)

        
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = context
        privateMOC.perform {
            
            do
            {
                let test = try context.fetch(fetchRequest)
                
                let objectToDelete = test[0] as! NSManagedObject
                context.delete(objectToDelete)
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Error: \(error), \(error.userInfo)")
                }
                catch
                {
                    print("Error  deleting: \(error)")
                }
                
            }
            catch
            {
                print("Error  deleting: \(error)")
            }
            
        }
        
        
    }
    
    
}

