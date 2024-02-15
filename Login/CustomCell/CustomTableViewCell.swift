import UIKit

class CustomTableViewCell: UITableViewCell {

    public var summaryButton: UIButton!
    private var dateLabel: UILabel!
    public var moreButton: UIButton!
    public var summaryClicked: (() -> Void)!
    public var moreButtonClicked: (() -> Void)!
    public var summaryButtonHeightConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        summaryButton = UIButton()
        summaryButton.titleLabel?.numberOfLines = 2
        summaryButton.titleLabel?.lineBreakMode = .byTruncatingTail
        summaryButton.setTitleColor(.black, for: .normal)
        summaryButton.contentHorizontalAlignment = .left
        summaryButton.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
        summaryButtonHeightConstraint = summaryButton.heightAnchor.constraint(equalToConstant: 50)
        summaryButtonHeightConstraint.isActive = false
        summaryButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(summaryButton)

        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(dateLabel)

        moreButton = UIButton()
        moreButton.setTitle("See More", for: .normal)
        moreButton.setTitleColor(.systemBlue, for: .normal)
        moreButton.isHidden = false
        moreButton.isEnabled = true
        moreButton.isUserInteractionEnabled = true
        moreButton.addTarget(self, action: #selector(handleVisible), for: .touchUpInside)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(moreButton)

        NSLayoutConstraint.activate([

            summaryButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            summaryButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            summaryButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
//            summaryButton.heightAnchor.constraint(equalToConstant: 50),
            
            dateLabel.topAnchor.constraint(equalTo: summaryButton.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),

            moreButton.topAnchor.constraint(equalTo: summaryButton.bottomAnchor, constant: 5),
            moreButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            moreButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(summary: String, date: String) {
        summaryButton.setTitle(summary, for: .normal)
        dateLabel.text = date
        
        if !summary.isEmpty {
            let lineCount = calculateLineCount(for: summary)
            moreButton.isHidden = lineCount < 2
        }
    }

    @objc public func handleUpdate() {
        summaryClicked()
    }

    @objc public func handleVisible() {
        moreButtonClicked()
    }
    
    private func calculateLineCount(for titleLabel: String) -> Int {
        let lineCount = titleLabel.components(separatedBy: .newlines).filter { !$0.isEmpty }.count
        return lineCount
    }
}
