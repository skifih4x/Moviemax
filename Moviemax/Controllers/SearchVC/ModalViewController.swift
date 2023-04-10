import UIKit

class CustomModalViewController: UIViewController {

    var visualEffectView: UIVisualEffectView!
    var categorySelectionView: UIView!
    var categories: [String] = ["All", "Action", "Adventure", "Mystery", "Fantasy", "Others"]
    var selectedCategory: String = "All"
    var starRating: Int = 1
    var applyFilterButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let screenHeight = UIScreen.main.bounds.height
        let viewHeight = screenHeight / 2
        let yPosition = screenHeight - viewHeight

        view.frame = CGRect(x: 0, y: yPosition, width: view.bounds.width, height: viewHeight)
    }

    func createButton(categoryTitle: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("  \(categoryTitle)  ", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        return button
    }

    lazy var upperCategoriesStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
     //   sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    lazy var lowerCategoriesStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
    //    sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    let categoriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    func setupUI() {

//        categories.forEach { cateogry in
//         let button = createButton(categoryTitle: cateogry)
//            upperCategoriesStackView.addArrangedSubview(button)
//        }

        for (index, category) in categories.enumerated() {
            if index < categories.count / 2 {
                let button = createButton(categoryTitle: category)
                   upperCategoriesStackView.addArrangedSubview(button)
            } else {
                let button = createButton(categoryTitle: category)
                lowerCategoriesStackView.addArrangedSubview(button)
            }
            }
        verticalStackView.addArrangedSubview(lowerCategoriesStackView)
        verticalStackView.addArrangedSubview(upperCategoriesStackView)


        view.addSubview(categoriesLabel)
        view.addSubview(verticalStackView)

        NSLayoutConstraint.activate([
            categoriesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            categoriesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            categoriesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])




        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            verticalStackView.heightAnchor.constraint(equalToConstant: 90)
        ])

        view.backgroundColor = .white
        // Add a label for the categories





        let starRatingLabel = UILabel()
        starRatingLabel.text = "Star Rating"
        starRatingLabel.textAlignment = .left
        starRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(starRatingLabel)

        NSLayoutConstraint.activate([
            starRatingLabel.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 80),
            starRatingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            starRatingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])

        // Configure the star rating buttons
        let starButtonSize = CGSize(width: 50, height: 50)
        let starButtonSpacing: CGFloat = 10
        let starButtonsViewWidth = CGFloat(starButtonSize.width * 5 + starButtonSpacing * 4)
        let starButtonsView = UIView(frame: CGRect(x: 0, y: 0, width: starButtonsViewWidth, height: starButtonSize.height))
        starButtonsView.translatesAutoresizingMaskIntoConstraints = false
        starButtonsView.layer.cornerRadius = starButtonSize.height / 2
        starButtonsView.layer.masksToBounds = true
        starButtonsView.backgroundColor = UIColor.white
        view.addSubview(starButtonsView)

        NSLayoutConstraint.activate([
            starButtonsView.topAnchor.constraint(equalTo: starRatingLabel.bottomAnchor, constant: 20),
            starButtonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starButtonsView.widthAnchor.constraint(equalToConstant: starButtonsViewWidth),
            starButtonsView.heightAnchor.constraint(equalToConstant: starButtonSize.height)
        ])

        for i in 1...5 {
            let button = UIButton(type: .system)
            button.setTitle("\(i)★", for: .normal)
            button.setTitleColor(.purple, for: .normal)
            button.addTarget(self, action: #selector(starButtonTapped(sender:)), for: .touchUpInside)
            button.frame = CGRect(x: CGFloat(i - 1) * (starButtonSize.width + starButtonSpacing), y: 0, width: starButtonSize.width, height: starButtonSize.height)
            button.layer.cornerRadius = starButtonSize.height / 2
            button.layer.masksToBounds = true
            starButtonsView.addSubview(button)
        }

        // Configure the Apply Filter button
        applyFilterButton = UIButton(type: .system)
        applyFilterButton.setTitle("Apply Filter", for: .normal)
        applyFilterButton.setTitleColor(.white, for: .normal)
        applyFilterButton.backgroundColor = .purple
        applyFilterButton.layer.cornerRadius = 10
        applyFilterButton.translatesAutoresizingMaskIntoConstraints = false
        applyFilterButton.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        self.view.addSubview(applyFilterButton)

        NSLayoutConstraint.activate([
            applyFilterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            applyFilterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            applyFilterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            applyFilterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func starButtonTapped(sender: UIButton) {
        if let title = sender.title(for: .normal) {
            starRating = Int(String(title.first!))!

            // Toggle the isSelected state of the button
            sender.isSelected = !sender.isSelected
        }
    }

    @objc func categoryChanged(_ sender: UIButton) {
        let index = sender.tag
        selectedCategory = categories[index]

        // Set the selected button's background color to purple
        sender.backgroundColor = .purple
        sender.setTitleColor(.white, for: .normal)

        // Reset the background color and title color of other buttons
        for button in self.view.subviews where button is UIButton && button.tag != index {
            let otherButton = button as! UIButton
            otherButton.backgroundColor = .white
            otherButton.setTitleColor(.purple, for: .normal)
        }
    }

    @objc func applyFilter() {
        // Perform the filtering operation based on selectedCategory and starRating
        //    delegate?.filterApplied(category: selectedCategory, starRating: starRating)

        // Dismiss the custom modal view controller
        self.dismiss(animated: true, completion: nil)
    }
}

