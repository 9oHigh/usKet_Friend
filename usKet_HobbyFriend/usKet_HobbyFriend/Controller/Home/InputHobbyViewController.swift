//
//  InputHobbyViewController.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/11.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class InputHobbyViewController: BaseViewController {
    
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.9, height: 0))
    
    let collectionView: UICollectionView = {
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = R.color.basicWhite()!
        return collectionView
    }()
    
    let findButton = UIButton().then {
        $0.backgroundColor = R.color.brandGreen()!
        $0.setTitle("새싹찾기", for: .normal)
        $0.setTitleColor(R.color.basicWhite()!, for: .normal)
        $0.titleLabel?.font = .toBodyR14
        $0.layer.cornerRadius = 10
    }
    var toggles: Bool = true
    let viewModel = InputHobbyViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setUI()
        setConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyBoardListener()
        collectionView.reloadData()
    }
    override func setConfigure() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        // SearchBar
        searchBar.placeholder = "띄어쓰기로 복수입력이 가능해요!"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        // collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(InputHobbyCollectionViewCell.self, forCellWithReuseIdentifier: InputHobbyCollectionViewCell.identifier)
        
        collectionView.register(CollectionSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionSectionHeader.identifier
        )
    }
    
    override func setUI() {
        
        view.addSubview(collectionView)
        view.addSubview(findButton)
    }
    
    override func setConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(120)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        findButton.snp.makeConstraints { make in
            make.bottom.equalTo(-25)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.snp.width).inset(30)
            make.height.equalTo(50)
        }
    }
    
    override func bind() {
        //        searchBar.rx.text.orEmpty
        //            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance) // 0.5초 기다림
        //            .distinctUntilChanged() // 같은 아이템을 받지 않는기능
        //            .subscribe(onNext: { [weak self]_ in
        //                self.items = self.samples.filter{ $0.hasPrefix(t)}
        //                self.tableView.reloadData()
        //
        //            }) .disposed(by: disposeBag)
        
    }
    
    // 키보드 노티
    private func addKeyBoardListener() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // 새싹찾기로 넘어갈시 제거
    private func removeKeyBoardListener() {
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        self.findButton.layer.cornerRadius = 0
        
        self.findButton.snp.updateConstraints { make in
            
            make.width.equalTo(self.view.snp.width)
            make.bottom.equalTo(-keyboardSize.height)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        self.findButton.layer.cornerRadius = 10
        
        self.findButton.snp.updateConstraints { make in
            
            make.width.equalTo(view.snp.width).inset(30)
            make.bottom.equalTo(-25)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
extension InputHobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        print(collectionView)
        print(kind)
        print("IndexPath: ", indexPath)
        print("Section: ", indexPath.section)
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionSectionHeader.identifier, for: indexPath) as! CollectionSectionHeader
        
        sectionHeader.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.top.bottom.equalTo(0)
        }
        
        sectionHeader.sectionHeaderlabel.text = indexPath.section == 0 ? "지금 주변에는" : "내가 하고싶은"
      
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InputHobbyCollectionViewCell.identifier, for: indexPath) as! InputHobbyCollectionViewCell
        if toggles {
            cell.hobbyLabel.text = "멍청이 입니당 X"
        } else {
            cell.hobbyLabel.text = "바보 XXXX"
        }
        toggles.toggle()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
        if toggles {
            label.text = "멍청이 입니당 X"
        } else {
            label.text = "바보 XXXX"
        }
        toggles.toggle()
        return label.intrinsicContentSize
    }
}
extension InputHobbyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 30
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 15, right: 0)
    }
}
