import UIKit

class TextFieldTableViewCell: UITableViewCell {

    class TextField: UITextField {

        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }

        override var intrinsicContentSize: CGSize{
            return .init(width: 20, height: 44)
        }
    }

    let textField: UITextField = {
        let txtField = TextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = "Text"
        return txtField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
