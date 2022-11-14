//
//  FormTableViewCell.swift
//  MuseApp
//
//  Created by Zoe Wende on 4/3/22.
//

import UIKit

protocol FormTableViewCellDelegate: AnyObject{
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel)
}

class FormTableViewCell: UITableViewCell, UITextFieldDelegate{
    
    static let identifier = "FormTableViewCell"
    
    public weak var delegate: FormTableViewCellDelegate?
    
    private var model: EditProfileFormModel?
    
    private let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AppYellow")
        label.numberOfLines = 1
        return label
    }()
    
    private let field: UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        field.backgroundColor = .black
        return field
        
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(formLabel)
        contentView.addSubview(field)
        field.delegate = self
        selectionStyle = .none
    }
    
    public func configure(with model: EditProfileFormModel){
        self.model = model
        formLabel.text = model.label
        field.attributedPlaceholder = NSAttributedString(string: model.placeholder,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        field.text = model.value
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        formLabel.text = nil
        field.placeholder = nil
        field.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        formLabel.frame = CGRect(x: 0, y: 0, width: contentView.width/3, height: contentView.height)
        field.frame = CGRect(x: formLabel.right + 5, y: 0, width: contentView.width-10-formLabel.width, height: contentView.height)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        model?.value = textField.text
        guard let model = model else {
            return true
        }

        delegate?.formTableViewCell(self, didUpdateField: model)
        textField.resignFirstResponder()
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
