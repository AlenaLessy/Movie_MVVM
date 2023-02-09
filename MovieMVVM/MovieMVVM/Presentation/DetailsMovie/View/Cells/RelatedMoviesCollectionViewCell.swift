// RelatedMoviesCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Ячейка рекомендованных фильмов
final class RelatedMoviesCollectionViewCell: UICollectionViewCell {
    // MARK: - Private Constants

    private enum Constants {
        static let movieImageViewCornerRadiusValue: CGFloat = 15
        static let movieImageViewHeightValue: CGFloat = 100
    }

    // MARK: - Private Outlets

    private var relatedContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        return view
    }()

    private var movieImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .brown
        image.layer.cornerRadius = Constants.movieImageViewCornerRadiusValue
        return image
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureLayoutAnchor()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
    }

    // MARK: - Public Methods

    func configure(_ movie: RecommendationMovie, viewModel: DetailsMovieViewModelProtocol) {
        viewModel.fetchRecommendationMoviePhoto(to: movie) { [weak self] data in
            guard let self else { return }
            self.movieImageView.image = UIImage(data: data)
        }
        reloadInputViews()
    }

    // MARK: - Private Methods

    private func addSubviews() {
        contentView.addSubview(movieImageView)
    }

    // MARK: - Constrains

    private func configureLayoutAnchor() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: Constants.movieImageViewHeightValue)
        ])
    }
}
