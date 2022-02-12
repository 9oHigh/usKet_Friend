//
//  InputHobbyCollectionViewCell.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/11.
//

import UIKit

final class InputHobbyCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "InputHobbyCollectionViewCell"
    let hobbyLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(hobbyLabel)
        
        hobbyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
