//
//  RecipeTableViewController.swift
//  HealthyApp
//
//  Created by Aryna Rudzevich on 11/30/19.
//  Copyright © 2019 Aryna Rudzevich. All rights reserved.
//

import UIKit
import os.log

class RecipeTableViewController: UITableViewController {
    //MARK: Properties
    
    var recipes = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.tintColor = UIColor.white
        
        // Add gradient to navigation bar
        guard
            let navigationController = navigationController,
            let flareGradientImage = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
            else {
                print("Error creating gradient color!")
                return
        }
        
        navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImage)
        
        // Load any saved recipes, otherwise load sample data.
        if let savedRecipes = loadRecipes() {
            recipes += savedRecipes
        } else {
            // Load the sample data.
            loadSampleRecipes()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RecipeTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecipeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RecipeTableViewCell.")
        }
        
        // Fetches the appropriate recipe for the data source layout.
        let recipe = recipes[indexPath.row]
        
        cell.nameLabel.text = recipe.name
        cell.photoImageView.image = recipe.photo
        cell.ratingControl.rating = recipe.rating
        cell.photoImageView.layer.cornerRadius = 20
        cell.photoImageView.clipsToBounds = true
        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            recipes.remove(at: indexPath.row)
            saveRecipes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //prepareForSegue
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddItem":
                os_log("Adding a new recipe.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let recipeDetailViewController = segue.destination as? RecipeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedRecipeCell = sender as? RecipeTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedRecipeCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedRecipe = recipes[indexPath.row]
            recipeDetailViewController.recipe = selectedRecipe
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
 
    
    //MARK: Actions
    @IBAction func unwindToRecipeList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as?
            RecipeViewController, let recipe = sourceViewController.recipe {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Edit an existing recipe
                recipes[selectedIndexPath.row] = recipe
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new recipe.
                let newIndexPath = IndexPath(row: recipes.count, section: 0)
                
                recipes.append(recipe)
                tableView.insertRows(at: [newIndexPath], with: .automatic) //animates the addition of a new row
            }
            saveRecipes()
        }
    }
    
    
    //MARK: Private Methods
    
    private func loadSampleRecipes() {
        let photo1 = UIImage(named: "recipe1")
        let photo2 = UIImage(named: "recipe2")
        let photo3 = UIImage(named: "recipe3")
        
        guard let recipe1 = Recipe(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate recipe1")
        }
        
        guard let recipe2 = Recipe(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate recipe2")
        }
        
        guard let recipe3 = Recipe(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate recipe3")
        }
        recipes = [recipe1, recipe2, recipe3]
        print(recipes)
    }

    private func saveRecipes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(recipes, toFile: Recipe.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Recipes successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save recipes...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadRecipes() -> [Recipe]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Recipe.ArchiveURL.path) as? [Recipe]
    }
    
}
