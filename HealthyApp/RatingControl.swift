import UIKit

@IBDesignable class RatingControl: UIStackView {
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var clockSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var clockCount: Int = 3 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index
        
       print(index)
        // Set the rating to the selected clock
        rating = selectedRating
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let clock15 = UIImage(named:"clock15", in: bundle, compatibleWith: self.traitCollection)
        let clock30 = UIImage(named:"clock30", in: bundle, compatibleWith: self.traitCollection)
        let clock60 = UIImage(named:"clock60", in: bundle, compatibleWith: self.traitCollection)
        let clockGreen = UIImage(named: "clockGreen", in: bundle, compatibleWith: self.traitCollection)
        let clockYellow = UIImage(named:"clockYellow", in: bundle, compatibleWith: self.traitCollection)
        let clockRed = UIImage(named:"clockRed", in: bundle, compatibleWith: self.traitCollection)
        
        for (index) in 0..<clockCount {
            // Create the button
            let button = UIButton()
            
            switch(index) {
            case 0:
                button.setImage(clock15, for: .normal)
                button.setImage(clockGreen, for: .selected)
                button.setImage(clockGreen, for: .highlighted)
                button.setImage(clockGreen, for: [.highlighted, .selected])
            case 1:
                button.setImage(clock30, for: .normal)
                button.setImage(clockYellow, for: .selected)
                button.setImage(clockYellow, for: .highlighted)
                button.setImage(clockYellow, for: [.highlighted, .selected])
            case 2:
                button.setImage(clock60, for: .normal)
                button.setImage(clockRed, for: .selected)
                button.setImage(clockRed, for: .highlighted)
                button.setImage(clockRed, for: [.highlighted, .selected])
            default:
                button.setImage(clock15, for: .normal)
            }
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: clockSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: clockSize.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)          
        }
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index == rating
        }
    }
}
