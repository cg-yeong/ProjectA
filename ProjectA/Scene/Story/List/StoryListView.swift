//
//  StoryListView.swift
//  ProjectA
//
//  Created by inforex on 2021/11/25.
//

import UIKit
import SwiftyJSON
import RxSwift
import RxCocoa

class StoryListView: XibView {
    
    @IBOutlet weak var another_view: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var close_button: UIButton!
    @IBOutlet weak var storyNone_view: UIView!
    @IBOutlet weak var super_view: UIView!
    
    var viewModel: StoryListViewModel!
    let bag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if initCheck {
            initialize()
            animateUp()
            initCheck = false
        }
    }
    
    override func removeFromSuperview() {
        animateDown { _ in
            super.removeFromSuperview()
        }
    }
    
    func initialize() {
        setLayout()
        bind()
        setTableView()
    }
    
    func setLayout() {
        setShadow()
    }
    
    func setShadow() {
        super_view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        super_view.layer.shadowOpacity = 1
        super_view.layer.shadowOffset = CGSize(width: 0, height: -8)
        super_view.layer.shadowRadius = 16
        let bounds = super_view.bounds
        let shadowPaath = UIBezierPath(rect: CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: bounds.height))).cgPath
        super_view.layer.shadowPath = shadowPaath
        super_view.layer.shouldRasterize = true
        super_view.layer.rasterizationScale = UIScreen.main.scale
    }
    
}

extension StoryListView {
    
    func bind() {
        
        let another_tap = UITapGestureRecognizer()
        another_view.addGestureRecognizer(another_tap)
        
        let input = StoryListViewModel.Input(close: close_button.rx.tap.map { _ in () },
                                             another_tap: another_tap.rx.event.map { _ in () })
        viewModel = StoryListViewModel(input)
        viewModel.setUp(viewData)
        viewModel.removeFromSuperview
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.animateDown { _ in
                    self.removeFromSuperview()
                }
            }.disposed(by: bag)
        
        viewModel.stories
            .bind { [weak self] storys in
                guard let self = self else { return }
                self.storyNone_view.isHidden = !storys.isEmpty
            }.disposed(by: bag)
        
    }
    
}

//extension StoryListView: UITableViewDelegate, UITableViewDataSource {
extension StoryListView {
    
    
    var storyCell: String { return "storyCell" }
    
    func setTableView() {
        tableView.register(UINib(nibName: storyCell, bundle: nil), forCellReuseIdentifier: storyCell)
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
//
//        tableView.delegate = self
//        tableView.dataSource = self
        setDataSource()
    }
    func setDataSource() {
        viewModel.stories
            .bind(to: tableView.rx.items(cellIdentifier: storyCell, cellType: StoryListCell.self)) { index, item, cell in
                cell.story = item
                cell.moreAction = self.viewModel.openMore(cell.story)
                cell.configCell()
            }.disposed(by: bag)
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
    
    
    
}
