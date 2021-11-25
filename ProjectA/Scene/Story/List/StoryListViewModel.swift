//
//  StoryListViewModel.swift
//  ProjectA
//
//  Created by inforex on 2021/11/25.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON
import Alamofire

class StoryListViewModel {
    
    struct Input {
        var close: Observable<Void>
        var another_tap: Observable<Void>
        
    }
    
    var removeFromSuperview: Driver<Void>
    var stories: BehaviorRelay<[List]>
    
    var model = StoryListModel()
    let bag = DisposeBag()
    
    init(_ input: Input) {
        
        stories = model.stories
        
        removeFromSuperview = model.removeFromSuperview
            .map { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
        
        input.close
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .map { _ in () }
            .bind(to: model.removeFromSuperview)
            .disposed(by: bag)
        
        input.another_tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .map { _ in () }
            .bind(to: model.removeFromSuperview)
            .disposed(by: bag)
        
        
        
    }
    
}

extension StoryListViewModel {
    
    func setUp(_ initData: JSON) {
        let viewer = MemInfo(name: initData["name"].stringValue,
                             email: initData["email"].stringValue,
                             profile_image: initData["profile_image"].stringValue,
                             contents: initData["contents"].string,
                             gender: initData["gender"].stringValue,
                             age: initData["age"].stringValue)
        self.model.viewer.accept(viewer)
        let page = self.model.page
        downloadStory(page)
    }
    
    func downloadStory(_ page: Int) {
        guard model.requestGuard else { return }
        model.requestGuard = false
        
        guard let viewer = self.model.viewer.value else { return }
        var storys = self.model.stories.value
        
        guard model.page <= model.totalPage else { return }
        
        let path = "http://pida83.gabia.io/api/story/page/\(page)"
        let params: Parameters = ["bj_id" : "\(viewer.email)"]
        RESTManager().request(path, method: .get, parameters: params) { [weak self] response in
            guard let self = self else { return }
            self.model.requestGuard = true
            guard let res = response else { return }
            let json = JSON(res)
            self.model.totalPage = json["total_page"].intValue
            let list: [List] = json["list"].arrayValue.map {
                let regNo = $0["reg_no"].stringValue
                let readYn = $0["read_yn"].stringValue
                let sentDate = $0["insDate"].stringValue
                let contents = $0["story_conts"].stringValue
                
                let fromSex = $0["send_mem_gender"].stringValue
                let fromPhoto = $0[List.CodingKeys.sendMemPhoto.rawValue].stringValue
                let fromName = $0["send_chat_name"].stringValue
                
//                let from = viewer
                let story = List(sendMemGender: fromSex, insDate: sentDate, sendMemPhoto: fromPhoto, storyConts: contents, sendChatName: fromName, regNo: regNo, readYn: readYn)
                
                return story
            }
            
            guard !list.isEmpty else { return }
            
            self.model.page += 1
            storys.append(contentsOf: list)
            self.model.stories.accept(storys)
        }
    }
    
    func delete(_ model: List) {
        var storys = self.model.stories.value
        storys = storys.filter { $0.regNo != model.regNo }
        self.model.stories.accept(storys)
    }
    
    func openMore(_ model: List) {
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { _ in
            self.delete(model)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let alertController = UIAlertController(title: nil, message: "더보기", preferredStyle: .actionSheet)
        alertController.addAction(deleteAction)
        alertController.addAction(cancel)
        if let vc = App.visibleViewController(){
            vc.present(alertController, animated: false)
        }
    }
    func pageUp() {
        downloadStory(model.page)
    }
}
