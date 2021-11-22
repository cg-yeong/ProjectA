//
//  StoryListViewController.swift
//  ProjectA
//
//  Created by inforex on 2021/07/12.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class StoryListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var storyListTableView: UITableView!
    
    var storyListData = [List]()
    var pageNum = 1
    var isPaging: Bool = false
    var hasNextpage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyListTableView.delegate = self
        storyListTableView.dataSource = self
        
        storyListTableView.register(UINib(nibName: "StoryCell", bundle: nil), forCellReuseIdentifier: "story")
        storyListTableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "loadingCell")
        
        let screenDidTap = UITapGestureRecognizer(target: self, action: #selector(screenDidTap))
        backView.addGestureRecognizer(screenDidTap)
//        paging()
    }
    
    // MARK: 시간 차이
    func setDateGap(indexPath: IndexPath) -> String {
        var resultTimeString: String = "오래전"
        let now = Date()
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(abbreviation: "GMT")
        date.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let writedDate = date.date(from: storyListData[indexPath.row].insDate) {
            let calendar = Calendar.current
            let timeGap = calendar.dateComponents([.day, .hour, .minute], from: writedDate, to: now)
            let overDay = timeGap.day ?? 0
            let overHour = timeGap.hour ?? 0
            let overMinute = timeGap.minute ?? 0
            
            if overDay > 0 {
                resultTimeString = "오래전"
            } else {
                if overHour > 0 {
                    resultTimeString = "\(overHour)시간전"
                } else {
                    resultTimeString = overMinute > 0 ? "\(overMinute)분전" : "방금 전"
                }
            }
            
        } // if let date END
        
        return resultTimeString
    }
    
    @objc func screenDidTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func downButton(_ sender: Any) {
        screenDidTap()
    }
    
    // MARK: - 테이블 뷰 페이징
    func beginPaging() {
        
        isPaging = true
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.pageNum += 1
            self.paging()
            
        }
    }
    func paging() {
        
        let urlString: String = "https://pida83.gabia.io/api/story/page/\(pageNum)"
        let parameter: Parameters = ["bj_id" : "geunyeong"]
        Alamofire.request(URL(string: urlString)!, method: .get, parameters: parameter, encoding: URLEncoding.queryString, headers: nil).responseData { [self] response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let moreList = try decoder.decode(StoryList.self, from: data)
                    if moreList.currentPage <= moreList.totalPage {
                        print("현재페이지:\(moreList.currentPage), 전체페이지:\(moreList.totalPage)")
                    }
                    storyListData.append(contentsOf: moreList.list)
                    hasNextpage = moreList.currentPage < moreList.totalPage ? true : false
                    isPaging = false
                    storyListTableView.reloadData()
                    DispatchQueue.main.async {
                        if storyListData.isEmpty {
                            storyListTableView.isHidden = true
                        }
                        
                    }
                } catch {
                    print("Data Not Found")
                    self.isPaging = false
                }
            case .failure(_):
                print(Error.self)
                print("alamofire request failure")
                self.isPaging = false
            }
        }
    }
    
    deinit {
        print("사연 리스트 deinit")
    }
}

extension StoryListViewController: UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = storyListTableView.contentOffset.y
        let contentHeight = storyListTableView.contentSize.height
        let height = storyListTableView.bounds.height
        
        if offsetY > (contentHeight - height) {
            if isPaging == false && hasNextpage {
                beginPaging()
            }
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let storyListCell = tableView.dequeueReusableCell(withIdentifier: "story", for: indexPath) as? StoryCell {
            
            storyListCell.send_mem_photo.layer.cornerRadius = storyListCell.send_mem_photo.frame.height / 2
            storyListCell.storyContsView.layer.cornerRadius = 5
            
            storyListCell.index = indexPath.row
            storyListCell.delegate = self
            
            storyListCell.send_chat_name.text = storyListData[indexPath.row].sendChatName
            storyListCell.story_contsLabel.text = storyListData[indexPath.row].storyConts
            
            // MARK: 보낸 시각으로부터 지금 시간까지의 전
            storyListCell.ins_date.text = setDateGap(indexPath: indexPath)
            
            // MARK: 사연 보낸 사람 사진
            if let sendmemPhotoStr = storyListData[indexPath.row].sendMemPhoto {
                if let photoURL = URL(string: sendmemPhotoStr) {
                    storyListCell.send_mem_photo.kf.setImage(with: photoURL)
                }
            } else {
                storyListCell.send_mem_photo.image = UIImage(named: "imgDefaultS")
            }
            
            // MARK: 사연 보낸 사람 성별
            let memberGender = storyListData[indexPath.row].sendMemGender
            if  memberGender == "m" {//, "M"
                storyListCell.send_mem_genderImageView.image = UIImage(named: "badgeSexM")
            } else if memberGender == "M" {
                storyListCell.send_mem_genderImageView.image = UIImage(named: "badgeSexM")
            } else {
                storyListCell.send_mem_genderImageView.image = UIImage(named: "badgeSexFm")
            }
            
            storyListCell.storyContsView.backgroundColor = storyListData[indexPath.row].readYn == "y" ? UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1) : UIColor(red: 241/255, green: 238/255, blue: 255/255, alpha: 1)
            // (238, 238, 238): 회색 , (241, 238, 255): 연보라색
            return storyListCell
        }
        return UITableViewCell()
        
    }
}

extension StoryListViewController: CustomCellEventDelegate {
    func moreEventButton(index: Int) {
        let alert = UIAlertController(title: "삭제", message: "받은 사연 중에서 선택한 사연을 삭제합니다. 삭제하시겠습니까?", preferredStyle: .actionSheet)
        let storyRemove = UIAlertAction(title: "삭제", style: .destructive) { action in
            print("삭제를 시도합니다")
            self.storyListData.remove(at: index)
            DispatchQueue.main.async {
                self.storyListTableView.reloadData()
            }
        }
        alert.addAction(storyRemove)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
