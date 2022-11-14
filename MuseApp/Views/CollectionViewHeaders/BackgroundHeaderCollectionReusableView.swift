//
//  BackgroundHeaderCollectionReusableView.swift
//  MuseApp
//
//  Created by Zoe Wende on 4/6/22.
//

import UIKit

class BackgroundHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "BackgroundHeaderCollectionReusableView"
    
//    let imageView = UIImageView()
    
     let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        frame = bounds

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    override init(frame: CGRect){
        super.init(frame: frame)
        self.setupUI()
        addSubview(imageView)
        clipsToBounds = true
        //imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    }
    
    private func setupUI(){
        self.addSubview(imageView)

        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: self.topAnchor),
                                     imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
                                     imageView.widthAnchor.constraint(equalToConstant: width),
                                     imageView.heightAnchor.constraint(equalToConstant: height)])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

//    public func configure(with model: User){
//        let thumbnailURL = model.background
//        imageView.sd_setImage(with: thumbnailURL, completed: nil)
//    }
//
//    public func configure(debug imageName: String){
//        imageView.image = UIImage(named: imageName)
//    }


}
