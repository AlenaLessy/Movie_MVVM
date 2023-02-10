// MoviesViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

// Экран выбора фильма
final class MoviesViewController: UIViewController {
    // MARK: - Private Constants

    private enum Constants {
        static let topRatedButtonTitle = "C лучшим рейтингом"
        static let popularButtonTitle = "Популярное"
        static let upCommingButtonTitle = "Скоро"
        static let movieTableCellIdentifier = "MovieTableCell"
        static let alertTitleText = "Ой!"
        static let alertMessageText = "Произошла ошибка(("
        static let alertActionTitleText = "Ok"
        static let cornerRadiusButtonValue: CGFloat = 5
        static let numberOfLinesZero = 0
        static let reducedAlphaOfButtonValue = 0.5
        static let buttonsAnimateDuration = 0.2
        static let tableViewWillDisplayRowDegreeValue = 60
        static let angel = 180.0
        static let tableViewRowAnimateDurationValue = 0.15
        static let tableViewRowAnimateDelayValue = 0.15
        static let moviesTableViewIdentifier = "Movies"
        static let cellIdentifier = "cellIdentifier"
        static let buttonAlphaFullValue = 1.0
        static let buttonAlphaHalfValue = 0.5
        static let titleAlertText = "Внимание"
        static let messageAlertText = "Введите ваш APIKEY"
    }

    private enum ConstantsOfConstraint {
        static let topRatedButtonLeadingOfSafeAreaValue: CGFloat = 10
        static let buttonHeightValue: CGFloat = 50
        static let buttonWidthValue: CGFloat = 110
        static let popularButtonLeadingOfTopRatedButtonValue: CGFloat = 15
        static let upCommingButtonLeadingOfpopularButtonValue: CGFloat = 15
        static let movieTableViewTopOftopRatedButtonValue: CGFloat = 20
    }

    // MARK: - Private Outlets

    private var topRatedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = Constants.cornerRadiusButtonValue
        button.setTitle(Constants.topRatedButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = Constants.numberOfLinesZero
        button.accessibilityIdentifier = MovieKind.topRated.rawValue
        return button
    }()

    private var popularButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = Constants.cornerRadiusButtonValue
        button.setTitle(Constants.popularButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.cyan, for: .selected)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = Constants.numberOfLinesZero
        button.alpha = Constants.reducedAlphaOfButtonValue
        button.accessibilityIdentifier = MovieKind.popular.rawValue
        return button
    }()

    private var upCommingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = Constants.cornerRadiusButtonValue
        button.setTitle(Constants.upCommingButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.cyan, for: .selected)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = Constants.numberOfLinesZero
        button.alpha = Constants.reducedAlphaOfButtonValue
        button.accessibilityIdentifier = MovieKind.upcoming.rawValue
        return button
    }()

    private var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .large
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        return refreshControl
    }()

    private lazy var movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        tableView.accessibilityIdentifier = Constants.moviesTableViewIdentifier
        return tableView
    }()

    // MARK: - Public Properties

    var moviesViewModel: MoviesViewModelProtocol!
    var showDetailsMovieHandler: IntHandler?
    var moviesViewData: MoviesViewData = .initial {
        didSet {
            view.setNeedsLayout()
        }
    }

    // MARK: - Public Methods

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        switch moviesViewData {
        case .initial:
            safeApiKey()
            setupUI()
            configureBindings()
            setupMoviesViewDataStatus()
        case .loading:
            moviesViewModel.refreshControlAction()
            activityIndicatorView.startAnimating()
        case .success:
            activityIndicatorView.stopAnimating()
            refreshControl.endRefreshing()
            movieTableView.reloadData()
        case .failure:
            showAlert(
                title: Constants.alertTitleText,
                message: Constants.alertMessageText,
                actionTitle: Constants.alertActionTitleText,
                handler: nil
            )
        }
    }

    // MARK: - Private Methods

    private func safeApiKey() {
        moviesViewModel.reloadApiKeyValue = { [weak self] in
            self?.showAlertWidthTextfield(
                title: Constants.alertTitleText,
                message: Constants.alertMessageText,
                actionTitle: Constants.alertActionTitleText
            ) { [weak self] apikey in
                self?.moviesViewModel.safeApiKey(value: apikey)
            }
        }
    }

    @objc private func refreshControlAction() {
        moviesViewModel.refreshControlAction()
    }

    @objc private func buttonAction(_ sender: UIButton) {
        moviesViewModel.handleChangedKind(to: sender.accessibilityIdentifier)
    }

    private func setupUI() {
        addSubviews()
        configureLayoutAnchor()
        configureTableView()
        buttonConfigure()
    }

    private func setupMoviesViewDataStatus() {
        moviesViewModel.moviesViewData = { [weak self] status in
            self?.moviesViewData = status
        }
    }

    private func buttonConfigure() {
        topRatedButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        popularButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        upCommingButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    private func addSubviews() {
        [
            topRatedButton,
            popularButton,
            upCommingButton,
            movieTableView
        ].forEach { view.addSubview($0) }
        movieTableView.addSubview(activityIndicatorView)
    }

    private func configureTableView() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: Constants.movieTableCellIdentifier)
    }

    private func configureBindings() {
        moviesViewModel.movieKindHandler = { [weak self] kind in
            guard let self else { return }
            self.movieTableView.setContentOffset(.zero, animated: true)
            UIView.animate(withDuration: Constants.buttonsAnimateDuration) {
                self.topRatedButton.alpha = kind == .topRated ? Constants.buttonAlphaFullValue : Constants
                    .buttonAlphaHalfValue
                self.popularButton.alpha = kind == .popular ? Constants.buttonAlphaFullValue : Constants
                    .buttonAlphaHalfValue
                self.upCommingButton.alpha = kind == .upcoming ? Constants.buttonAlphaFullValue : Constants
                    .buttonAlphaHalfValue
                self.view.layoutIfNeeded()
            }
        }
    }

    // MARK: - Constrains

    private func configureLayoutAnchor() {
        topRatedButtonConstraint()
        popularButtonConstraint()
        upCommingButtonConstraint()
        movieTableViewConstraint()
        activityIndicatorViewConstraint()
    }

    private func topRatedButtonConstraint() {
        NSLayoutConstraint.activate([
            topRatedButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topRatedButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: ConstantsOfConstraint.topRatedButtonLeadingOfSafeAreaValue
            ),
            topRatedButton.heightAnchor.constraint(equalToConstant: ConstantsOfConstraint.buttonHeightValue),
            topRatedButton.widthAnchor.constraint(equalToConstant: ConstantsOfConstraint.buttonWidthValue)
        ])
    }

    private func popularButtonConstraint() {
        NSLayoutConstraint.activate([
            popularButton.topAnchor.constraint(equalTo: topRatedButton.topAnchor),
            popularButton.leadingAnchor.constraint(
                equalTo: topRatedButton.trailingAnchor,
                constant: ConstantsOfConstraint.popularButtonLeadingOfTopRatedButtonValue
            ),
            popularButton.heightAnchor.constraint(equalToConstant: ConstantsOfConstraint.buttonHeightValue),
            popularButton.widthAnchor.constraint(equalToConstant: ConstantsOfConstraint.buttonWidthValue)
        ])
    }

    private func upCommingButtonConstraint() {
        NSLayoutConstraint.activate([
            upCommingButton.topAnchor.constraint(equalTo: topRatedButton.topAnchor),
            upCommingButton.leadingAnchor.constraint(
                equalTo: popularButton.trailingAnchor,
                constant: ConstantsOfConstraint.upCommingButtonLeadingOfpopularButtonValue
            ),
            upCommingButton.heightAnchor.constraint(equalToConstant: ConstantsOfConstraint.buttonHeightValue),
            upCommingButton.widthAnchor.constraint(equalToConstant: ConstantsOfConstraint.buttonWidthValue)
        ])
    }

    private func movieTableViewConstraint() {
        NSLayoutConstraint.activate([
            movieTableView.topAnchor.constraint(
                equalTo: topRatedButton.bottomAnchor,
                constant: ConstantsOfConstraint.movieTableViewTopOftopRatedButtonValue
            ),
            movieTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func activityIndicatorViewConstraint() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

/// UITableViewDataSource
extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesViewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.movieTableCellIdentifier)
            as? MovieTableViewCell
        else { return UITableViewCell() }
        let movie = moviesViewModel.movies[indexPath.row]
        cell.configure(movie: movie, viewModel: moviesViewModel)
        cell.accessibilityIdentifier = "\(Constants.cellIdentifier)\(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let degree = Constants.tableViewWillDisplayRowDegreeValue
        let rotationAngel = CGFloat(Double(degree) * .pi / Constants.angel)
        let rotationPTransform = CATransform3DMakeRotation(rotationAngel, 1, 0, 0)
        cell.layer.transform = rotationPTransform
        UIView.animate(
            withDuration: Constants.tableViewRowAnimateDurationValue,
            delay: Constants.tableViewRowAnimateDelayValue
        ) {
            cell.layer.transform = CATransform3DIdentity
        }
        moviesViewModel.newFetchMovies(to: indexPath.row)
    }
}

/// UITableViewDelegate
extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieId = moviesViewModel.movies[indexPath.row].id
        showDetailsMovieHandler?(movieId)
    }
}
