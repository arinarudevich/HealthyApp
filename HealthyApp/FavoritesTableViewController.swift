import UIKit
import os.log


class FavoritesTableViewController: UITableViewController {
    var recipes = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        guard
            let navigationController = navigationController,
            let flareGradientImage = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
            else {
                print("Error creating gradient color!")
                return
        }
        
        navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImage)
        
        recipes = loadRecipes()!.filter {$0.isFavorite}

        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        cell.instructionTextView.text = recipe.instruction
        
        cell.photoImageView.layer.cornerRadius = 20
        cell.photoImageView.clipsToBounds = true
        
        return cell
    }
    
    
    //MARK: Private Methods
    
    private func saveRecipes() {
        HealthyAppModel.saveRecipes(recipes: recipes)
    }
    
    private func loadRecipes() -> [Recipe]? {
        return HealthyAppModel.retrieveSavedRecipes()
    }
    
}
