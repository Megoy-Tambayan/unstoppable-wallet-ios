import UIKit
import ThemeKit
import SnapKit
import ComponentKit

class BalanceCell: UITableViewCell {
    private static let margins = UIEdgeInsets(top: .margin8, left: .margin16, bottom: 0, right: .margin16)

    private let cardView = CardView(insets: .zero)

    private let topView = BalanceTopView()
    private let separatorView = UIView()
    private let lockedAmountView = BalanceLockedAmountView()
    private let buttonsView = BalanceButtonsView()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(Self.margins)
        }

        cardView.contentView.addSubview(topView)
        topView.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalToSuperview()
            maker.height.equalTo(BalanceTopView.height)
        }

        cardView.contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(CGFloat.margin12)
            maker.bottom.equalTo(topView).offset(BalanceTopView.expandedMargin)
            maker.height.equalTo(CGFloat.heightOneDp)
        }

        separatorView.backgroundColor = .themeSteel20

        cardView.contentView.addSubview(lockedAmountView)
        lockedAmountView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(separatorView.snp.bottom)
            maker.height.equalTo(BalanceLockedAmountView.height)
        }

        cardView.contentView.addSubview(buttonsView)
        buttonsView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(lockedAmountView.snp.bottom)
            maker.height.equalTo(BalanceButtonsView.height)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    func bind(viewItem: BalanceViewItem, animated: Bool = false, duration: TimeInterval = 0.2, onSend: @escaping () -> (), onWithdraw: @escaping () -> (), onReceive: @escaping () -> (), onDeposit: @escaping () -> (), onSwap: @escaping () -> (), onChart: @escaping () -> (), onTapError: (() -> ())?) {
        topView.bind(viewItem: viewItem.topViewItem, onTapError: onTapError)
        topView.layoutIfNeeded()

        separatorView.set(hidden: viewItem.buttons == nil, animated: animated, duration: duration)

        if let viewItem = viewItem.lockedAmountViewItem {
            lockedAmountView.bind(viewItem: viewItem)
            lockedAmountView.layoutIfNeeded()
        }

        lockedAmountView.set(hidden: viewItem.lockedAmountViewItem == nil, animated: animated, duration: duration)
        lockedAmountView.snp.updateConstraints { maker in
            maker.height.equalTo(viewItem.lockedAmountViewItem != nil ? BalanceLockedAmountView.height : 0)
        }

        if animated {
            UIView.animate(withDuration: duration) {
                self.contentView.layoutIfNeeded()
            }
        }

        if let buttons = viewItem.buttons {
            buttonsView.bind(buttons: buttons, sendAction: onSend, withdrawAction: onWithdraw, receiveAction: onReceive, depositAction: onDeposit, swapAction: onSwap, chartAction: onChart)
        }
        buttonsView.set(hidden: viewItem.buttons == nil, animated: animated, duration: duration)
    }

    static func height(viewItem: BalanceViewItem) -> CGFloat {
        var height: CGFloat = margins.height

        height += BalanceTopView.height

        if viewItem.lockedAmountViewItem != nil {
            height += BalanceLockedAmountView.height
        }

        if viewItem.buttons != nil {
            height += BalanceTopView.expandedMargin
            height += BalanceButtonsView.height
        }

        return height
    }

}
