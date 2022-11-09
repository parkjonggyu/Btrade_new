//
//  PopupDate.swift
//  Btrade
//
//  Created by 블록체인컴퍼니 on 2022/10/13.
//

import Foundation
import UIKit
import FSCalendar

class PopupDate:UIViewController{
    
 
    @IBOutlet weak var popupLayout: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBOutlet weak var yyyymmText: UILabel!
    
    @IBOutlet weak var rightOneBtn: UIImageView!
    @IBOutlet weak var rightTwoBtn: UIImageView!
    
    @IBOutlet weak var leftOneBtn: UIImageView!
    @IBOutlet weak var leftTowBtn: UIImageView!
    
    var currentPage:Date!
    var selectDate:Date?
    var delegate:((Date) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        
        
        rightOneBtn.isUserInteractionEnabled = true
        rightOneBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.moveMonth)))
        rightTwoBtn.isUserInteractionEnabled = true
        rightTwoBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.moveMonth)))
        leftOneBtn.isUserInteractionEnabled = true
        leftOneBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.moveMonth)))
        leftTowBtn.isUserInteractionEnabled = true
        leftTowBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.moveMonth)))
    }
    
    @objc func moveMonth(sender:UITapGestureRecognizer){
        if(sender.view == rightOneBtn){
            moveMonth1(1)
        }else if(sender.view == rightTwoBtn){
            moveMonth1(12)
        }else if(sender.view == leftOneBtn){
            moveMonth1(-1)
        }else if(sender.view == leftTowBtn){
            moveMonth1(-12)
        }
    }
    
    fileprivate func moveMonth1(_ add:Int){
        let date = Calendar.current.date(byAdding: .month, value: add, to: currentPage)
        calendarView.setCurrentPage(date!, animated: true)
    }
    
    @objc func selectedTab(sender:UITapGestureRecognizer){
        if(sender.view == backBtn){
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func goNext(_ sender: Any) {
        if let date = selectDate{
            if let d = delegate{
                d(date)
                self.dismiss(animated: true)
            }
        }
    }
    
    fileprivate func setLayout(){
        calendarView.dataSource = self
        calendarView.delegate = self
        
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedTab)))
        
        popupLayout.clipsToBounds = true
        popupLayout.layer.cornerRadius = 30
        popupLayout.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        calendarView.calendarWeekdayView.weekdayLabels[0].text = "일"
        calendarView.calendarWeekdayView.weekdayLabels[1].text = "월"
        calendarView.calendarWeekdayView.weekdayLabels[2].text = "화"
        calendarView.calendarWeekdayView.weekdayLabels[3].text = "수"
        calendarView.calendarWeekdayView.weekdayLabels[4].text = "목"
        calendarView.calendarWeekdayView.weekdayLabels[5].text = "금"
        calendarView.calendarWeekdayView.weekdayLabels[6].text = "토"
        
        calendarView.calendarWeekdayView.weekdayLabels[0].textColor = UIColor(named: "CA1A1A1")
        calendarView.calendarWeekdayView.weekdayLabels[1].textColor = UIColor(named: "CA1A1A1")
        calendarView.calendarWeekdayView.weekdayLabels[2].textColor = UIColor(named: "CA1A1A1")
        calendarView.calendarWeekdayView.weekdayLabels[3].textColor = UIColor(named: "CA1A1A1")
        calendarView.calendarWeekdayView.weekdayLabels[4].textColor = UIColor(named: "CA1A1A1")
        calendarView.calendarWeekdayView.weekdayLabels[5].textColor = UIColor(named: "CA1A1A1")
        calendarView.calendarWeekdayView.weekdayLabels[6].textColor = UIColor(named: "CA1A1A1")
        
        setYYYYMMText(Date())
    }
    
    fileprivate func setYYYYMMText(_ date:Date){
        currentPage = date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        yyyymmText.text = formatter.string(from: date)
    }
}

extension PopupDate:FSCalendarDelegate,FSCalendarDataSource, FSCalendarDelegateAppearance, FSCalendarCollectionViewInternalDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectDate = date
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        setYYYYMMText(calendar.currentPage)
    }
    
}
    
