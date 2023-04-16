import UIKit

enum CGConstants: CGFloat {
    case paddingBetweenButtons = 12
}

class FilterModalViewController: UIViewController {


    weak var delegate: FilterViewControllerDelegate?
    var visualEffectView: UIVisualEffectView!
    var categorySelectionView: UIView!
  //  var categories: [MovieGenre] = ["all", "Action", "Adventure", "Mystery", "Fantasy", "Others"]
    var categories: [MovieGenre] = [.all, .action, .adventure, .mystery, .fantasy, .comedy]
    var categoriesButtons = [UIButton]()
    var starsButtons = [UIButton]()

    var selectedCategory: MovieGenre?
    var selectedRating: Double?

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

        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        view.frame = CGRect(x: 0, y: yPosition, width: view.bounds.width, height: viewHeight)
    }


    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("⤬ Filter", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)

        return button
    }()

    lazy var resetFiltersButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reset Filters", for: .normal)
        button.setTitleColor(.customPurple, for: .normal)
        button.addTarget(self, action: #selector(resetFiltersButtonPressed), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()

    lazy var upperCategoriesStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = CGConstants.paddingBetweenButtons.rawValue
        return sv
    }()

    lazy var lowerCategoriesStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = CGConstants.paddingBetweenButtons.rawValue
        return sv
    }()

    lazy var overallCategoriesStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    lazy var upperStarsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = CGConstants.paddingBetweenButtons.rawValue
        return sv
    }()

    lazy var lowerStarsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = CGConstants.paddingBetweenButtons.rawValue
        return sv
    }()

    lazy var overallStarsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
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

    func createButton(categoryTitle: String, tag: Int) -> FilterButton {
        let button = FilterButton(type: .system)
        button.setTitle(categoryTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(categoryChanged), for: .touchUpInside)
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        categoriesButtons.append(button)
        return button
    }


    fileprivate func configureApplyButton() {
        // Configure the Apply Filter button
        applyFilterButton = UIButton(type: .system)
        applyFilterButton.setTitle("Apply Filter", for: .normal)
        applyFilterButton.setTitleColor(.white, for: .normal)
        applyFilterButton.backgroundColor = .customPurple
        applyFilterButton.layer.cornerRadius = 12
        applyFilterButton.translatesAutoresizingMaskIntoConstraints = false
        applyFilterButton.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        view.addSubview(applyFilterButton)

        NSLayoutConstraint.activate([
            applyFilterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            applyFilterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            applyFilterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            applyFilterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    fileprivate func configureStarsStackView() {
        let starRatingLabel = UILabel()
        starRatingLabel.text = "Star Rating"
        starRatingLabel.textAlignment = .left
        starRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(starRatingLabel)

        NSLayoutConstraint.activate([
            starRatingLabel.topAnchor.constraint(equalTo: overallCategoriesStackView.bottomAnchor, constant: 16),
            starRatingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            starRatingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        view.addSubview(overallStarsStackView)
        overallStarsStackView.addArrangedSubview(upperStarsStackView)
        overallStarsStackView.addArrangedSubview(lowerStarsStackView)

        for i in 1...5 {
            let button = UIButton(type: .system)
            button.setTitle(String(repeating: "★", count: i), for: .normal)
            button.setTitleColor(.systemYellow, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 20)

            button.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
            button.layer.cornerRadius = 20
            button.contentEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray.cgColor
            button.layer.masksToBounds = true
            starsButtons.append(button)
            if i <= 3 {
                upperStarsStackView.addArrangedSubview(button)
            } else {
                lowerStarsStackView.addArrangedSubview(button)
            }
        }

        NSLayoutConstraint.activate([
            overallStarsStackView.topAnchor.constraint(equalTo: starRatingLabel.bottomAnchor, constant: 10),
            overallStarsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            overallStarsStackView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    func setupUI() {

        view.addSubview(dismissButton)

        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            dismissButton.heightAnchor.constraint(equalToConstant: 35),
        ])

        view.addSubview(resetFiltersButton)

        NSLayoutConstraint.activate([
            resetFiltersButton.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            resetFiltersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            resetFiltersButton.heightAnchor.constraint(equalToConstant: 35)
        ])

        for (index, category) in categories.enumerated() {
            if index < categories.count / 2 {
                let button = createButton(categoryTitle: category.name, tag: index)
                   upperCategoriesStackView.addArrangedSubview(button)
            } else {
                let button = createButton(categoryTitle: category.name, tag: index)
                lowerCategoriesStackView.addArrangedSubview(button)
            }
            }

        overallCategoriesStackView.addArrangedSubview(upperCategoriesStackView)
        overallCategoriesStackView.addArrangedSubview(lowerCategoriesStackView)

        view.addSubview(categoriesLabel)
        view.addSubview(overallCategoriesStackView)

        NSLayoutConstraint.activate([
            categoriesLabel.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 4),
            categoriesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            categoriesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            overallCategoriesStackView.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: 10),
            overallCategoriesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            overallCategoriesStackView.heightAnchor.constraint(equalToConstant: 90)
        ])

        view.backgroundColor = .white

        configureStarsStackView()

        configureApplyButton()
    }

    @objc func starButtonTapped(sender: UIButton) {
        starsButtons.forEach { button in
            button.layer.borderColor = UIColor.systemGray.cgColor
        }
        sender.layer.borderColor = UIColor.customPurple?.cgColor
        if let selectedRating = starsButtons.firstIndex(of: sender) {
            self.selectedRating = Double((selectedRating + 1) * 2)
        }
    }

    @objc func categoryChanged(_ sender: UIButton) {
        if let index = categoriesButtons.firstIndex(of: sender) {
            selectedCategory = categories[index]
        }

        categoriesButtons.forEach { button in
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }

        // Set the selected button's background color to purple
        sender.backgroundColor = .customPurple
        sender.setTitleColor(.white, for: .normal)

        // Reset the background color and title color of other buttons

    }

    @objc
    private func resetFiltersButtonPressed() {
        categoriesButtons.forEach { button in
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }

        selectedCategory = nil

        starsButtons.forEach { button in
            button.layer.borderColor = UIColor.systemGray.cgColor
        }

        selectedRating = nil
    }

    @objc
    private func dismissButtonPressed() {
        selectedRating = nil
        selectedCategory = nil

        applyFilter()
    }

    @objc func applyFilter() {
        delegate?.filterApplied(category: selectedCategory, starRating: selectedRating)
        dismiss(animated: true, completion: nil)
    }
}

protocol FilterViewControllerDelegate: AnyObject {
    func filterApplied(category: MovieGenre?, starRating: Double?)
}

