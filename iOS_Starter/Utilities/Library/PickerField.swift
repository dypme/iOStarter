//
//  InputViewPickerField.swift
//  HalloWorld
//
//  Created by Crocodic MBP-2 on 10/31/17.
//  Copyright © 2017 Crocodic Studio. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PickerField: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// Initialize new picker in input field with textfield
    ///
    /// - Parameter textField: Textfield for store input picker
    init(textField: UITextField) {
        super.init(frame: .zero)
        self.textField = textField
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum InputType {
        case picker, date
    }
    
    /// Type of input picker
    private(set) var type: InputType = .picker
    /// Setting custom font, color, information from picker
    private(set) var appearance = Appearance()
    
    /// Picker for input type picker
    fileprivate var picker: UIPickerView!
    /// Picker for input type date
    fileprivate var datePicker: UIDatePicker!
    /// Data for input picker
    fileprivate var data = [String]()
    
    /// Position, current picker select
    fileprivate var selectedRow: Int = 0
    
    /// Action when selected picker
    private var pickerCallback: ((String, Int) -> Void)? = nil
    
    /// Action when selected date picker
    private var dateCallback: ((Date) -> Void)? = nil
    
    /// Textfield that input from picker
    var textField: UITextField!
    /// View that block user to interaction in behind input picker
    private var blockerView: UIView!
    
    /// Start to create input picker field
    @objc private func textFieldDidBeginEditing() {
        if picker != nil || datePicker != nil {
            setup()
            addBlocker()
        }
    }
    
    /// Stop input field
    @objc private func textFieldDidEndEditing() {
        verifyData()
        removeBlocker()
    }
    
    /// Create blocker view
    private func addBlocker() {
        if appearance.isHiddenBlocker {
            return
        }
        
        let window = UIApplication.shared.keyWindow!
        blockerView = UIView(frame: window.frame)
        blockerView.isUserInteractionEnabled = true
        blockerView.setTapGesture(target: self, action: #selector(cancel))
        blockerView.backgroundColor = appearance.blockerColor.withAlphaComponent(0.63)
        window.addSubview(blockerView)
        
        blockerView.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.blockerView.alpha = 1.0
        }
    }
    
    /// Remove blocker view
    private func removeBlocker() {
        if appearance.isHiddenBlocker {
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.blockerView.alpha = 0.0
        }) { (finished) in
            if finished {
                self.blockerView.removeFromSuperview()
            }
        }
    }
    
    /// Check input data in textFIeld is true
    private func verifyData() {
        if picker != nil || datePicker != nil {
            switch type {
            case .picker:
                if !data.contains(textField.text!) {
                    textField.text = ""
                }
            case .date:
                if datePicker.datePickerMode == .date {
                    if textField.text!.pickerFieldDate(format: appearance.dateFormat) == nil {
                        self.textField.text = ""
                    }
                } else if datePicker.datePickerMode == .time {
                    if textField.text!.pickerFieldDate(format: appearance.timeFormat) == nil {
                        self.textField.text = ""
                    }
                } else if datePicker.datePickerMode == .dateAndTime {
                    if textField.text!.pickerFieldDate(format: appearance.dateFormat + " " + appearance.timeFormat) == nil {
                        self.textField.text = ""
                    }
                }
            }
        }
    }
    
    /// Setup input date picker view in field
    ///
    /// - Parameters:
    ///   - datePicker: Custom date picker
    ///   - mode: Date picker mode for use in input field
    ///   - callback: Action when selected date picker
    func setDatePicker(_ datePicker: UIDatePicker? = nil, mode: UIDatePicker.Mode? = nil, completion callback: ((Date) -> Void)? = nil) {
        removePicker()
        
        self.type = .date
        self.datePicker = datePicker
        
        if let datePicker = datePicker {
            self.datePicker = datePicker
        } else {
            self.datePicker = UIDatePicker()
            self.datePicker.locale = Locale(identifier: Config.shared.GLOBAL_LOCALE)
        }
        
        if let mode = mode {
            self.datePicker.datePickerMode = mode
        }
        
        self.dateCallback = callback
        
        setupField()
        reloadPicker()
    }
    
    /// Setup input picker view in field
    ///
    /// - Parameters:
    ///   - data: Data for using in picker
    ///   - picker: Custom picker
    ///   - callback: Action when selected picker
    func setPicker(data: [String], picker: UIPickerView = UIPickerView(), completion callback: ((String, Int) -> Void)? = nil) {
        removePicker()
        
        self.type = .picker
        self.picker = picker
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        self.data = data
        self.pickerCallback = callback
        picker.reloadAllComponents()
        
        setupField()
        reloadPicker()
    }
    
    /// Reload picker data and setting
    func reloadPicker() {
        if picker != nil || datePicker != nil {
            setup()
        }
    }
    
    /// Remove picker from input view field
    func removePicker() {
        textField.removeTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        textField.removeTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        textField.tintColor = textField.textColor
        
        picker = nil
        datePicker = nil
        
        textField.resignFirstResponder()
        textField.inputView = nil
    }
    
    /// Setup target for field
    private func setupField() {
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        textField.tintColor = UIColor.clear
    }
    
    /// Select date with specific date
    ///
    /// - Parameter date: Date that want select
    func selectDate(_ date: Date) {
        if type == .date {
            if isAlwaysUpdate {
                datePicker.setDate(date, animated: false)
                if datePicker.datePickerMode == .date {
                    self.textField.text = datePicker.date.pickerFieldString(format: appearance.dateFormat)
                } else if datePicker.datePickerMode == .time {
                    self.textField.text = datePicker.date.pickerFieldString(format: appearance.timeFormat)
                } else if datePicker.datePickerMode == .dateAndTime {
                    self.textField.text = datePicker.date.pickerFieldString(format: appearance.dateFormat + " " + appearance.timeFormat)
                }
            }
        } else {
            print("Your picker type not date, please change type first")
        }
    }
    
    /// Select picker with specific index
    ///
    /// - Parameter index: Index position that want select
    func selectPicker(index: Int) {
        if type == .picker {
            if !data.isEmpty {
                if isAlwaysUpdate {
                    selectedRow = index
                    picker.selectRow(index, inComponent: 0, animated: false)
                    self.textField.text = data[index]
                }
            }
        } else {
            print("Your picker type not picker, please change type first")
        }
    }
    
    /// Select picker with specific data
    ///
    /// - Parameter data: Specific data that want select
    func selectPicker(data aData: String) {
        if type == .picker {
            if !data.isEmpty {
                if isAlwaysUpdate {
                    guard let index = data.index(of: aData) else {
                        print("Your select data not contains in master data")
                        return
                    }
                    
                    selectedRow = index
                    picker.selectRow(index, inComponent: 0, animated: false)
                    self.textField.text = data[index]
                }
            }
        } else {
            print("Your picker type not picker, please change type first")
        }
    }
    
    /// Setup all input picker for show
    private func setup() {
        if data.isEmpty && type == .picker {
            textField.inputAccessoryView = nil
            textField.inputView = nil
            return
        }
        
        let tintColor: UIColor = appearance.backgroundColor
        let currentWindow = UIScreen.main.bounds
        
        self.frame = CGRect(x: 0, y: 0, width: currentWindow.width, height: 215)
        self.backgroundColor = tintColor
        
        switch type {
        case .date:
            datePicker.frame = self.frame
            datePicker.tintColor = tintColor
            datePicker.setValue(appearance.pickerColor, forKeyPath: "textColor")
            self.addSubview(datePicker) // add date picker to UIView
        default:
            picker.frame = self.frame
            picker.tintColor = tintColor
            self.addSubview(picker) // add picker to UIView
        }
        
        let toolBarView = UIView(frame: CGRect(x: -1, y: 0, width: currentWindow.width + 2, height: 50))
        toolBarView.layer.borderWidth = 0.6
        toolBarView.layer.borderColor = UIColor.lightGray.cgColor
        toolBarView.backgroundColor = appearance.toolbarBackgroundColor
        
        let titleLabel = UILabel(frame: CGRect(x: 80, y: 0, width: currentWindow.width - 160, height: 50))
        titleLabel.contentScaleFactor = 0.7
        titleLabel.textAlignment = .center
        titleLabel.font = appearance.toolbarTitleFont
        titleLabel.textColor = appearance.toolbarTitleColor
        titleLabel.text = textField.placeholder
        toolBarView.addSubview(titleLabel)
        
        let doneButton = UIButton(frame: CGRect(x: currentWindow.maxX - 80, y: 0, width: 80, height: 50))
        doneButton.setTitleColor(appearance.selectColor, for: UIControl.State())
        doneButton.setTitle(appearance.selectText, for: UIControl.State())
        doneButton.titleLabel?.font = appearance.toolbarFont
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        toolBarView.addSubview(doneButton)
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
        cancelButton.setTitleColor(appearance.cancelColor, for: UIControl.State())
        cancelButton.setTitle(appearance.cancelText, for: UIControl.State())
        cancelButton.titleLabel?.font = appearance.toolbarFont
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        toolBarView.addSubview(cancelButton)
        
        textField.inputAccessoryView = toolBarView
        textField.inputView = self
    }

    /// Action cancel button in toolbar
    @objc private func cancel() {
        textField.resignFirstResponder()
    }
    
    /// Action select button in toolbar
    @objc private func done() {
        switch type {
        case .date:
            if isAlwaysUpdate {
                selectDate(datePicker.date)
                dateCallback?(datePicker.date)
            }
        default:
            if isAlwaysUpdate {
                selectPicker(index: selectedRow)
                pickerCallback?(data[selectedRow], selectedRow)
            }
        }
        
        textField.resignFirstResponder()
    }
    
    /// Checking picker need to always update
    private var isAlwaysUpdate: Bool {
        switch type {
        case .date:
            if self.textField.text!.lowercased() == datePicker.date.pickerFieldString(format: appearance.dateFormat).lowercased() && !appearance.isAlwaysUpdate {
                return false
            }
        default:
            if self.textField.text!.lowercased() == data[selectedRow].lowercased() && !appearance.isAlwaysUpdate {
                return false
            }
        }
        return true
    }
}

extension PickerField {
    class Appearance {
        /// Select button color
        var selectColor: UIColor = UIColor.black
        /// Select button text
        var selectText = LocalizeHelper.pickerFieldSelect
        /// Cancel button color
        var cancelColor: UIColor = UIColor.red
        /// Cancel button text
        var cancelText = LocalizeHelper.pickerFieldCancel
        /// Toolbar background color
        var toolbarBackgroundColor: UIColor = UIColor.white
        /// Toolbar button font
        var toolbarFont: UIFont? = UIFont.systemFont(ofSize: 13)
        /// Toolbar title color
        var toolbarTitleColor: UIColor = UIColor.lightGray
        /// Toolbar title font
        var toolbarTitleFont: UIFont? = UIFont.systemFont(ofSize: 15)
        
        /// Picker background color
        var backgroundColor: UIColor = UIColor(red: 248/255.0, green: 247/255.0, blue: 244/255.0, alpha: 1.0)
        /// Picker text font
        var pickerFont: UIFont? = UIFont.systemFont(ofSize: 20)
        /// Picker text color
        var pickerColor = UIColor.black
        
        /// Format selected date that show in field
        var dateFormat: String = "dd MMMM yyyy"
        /// Format selected time that show in field
        var timeFormat: String = "HH:mm"
        
        /// Get callback update action although selected data same as before
        var isAlwaysUpdate: Bool = false
        
        /// Blocker background color
        var blockerColor = UIColor.black
        /// A Boolean value that determines whether the input view is contain blocker.
        var isHiddenBlocker = false
    }
}

extension PickerField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = appearance.pickerFont
        label.textColor = appearance.pickerColor
        label.textAlignment = .center
        label.text = data[row]
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = data[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font: appearance.pickerFont!, NSAttributedString.Key.foregroundColor: appearance.pickerColor])
        return myTitle
    }
}

extension Date {
    /// Formatting string from date
    ///
    /// - Parameter format: Format date want. Check this [link](http://nsdateformatter.com/) for all about formatting date in swift
    /// - Returns: String of date after formatting
    fileprivate func pickerFieldString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Config.shared.GLOBAL_LOCALE)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String {
    /// Convert string format date to Date data type
    ///
    /// - Parameter format: Current format string date
    /// - Returns: Date from string
    fileprivate func pickerFieldDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Config.shared.GLOBAL_LOCALE)
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
}
