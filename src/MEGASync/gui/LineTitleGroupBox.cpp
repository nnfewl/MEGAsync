#include "LineTitleGroupBox.h"

#include "TokenParserWidgetManager.h"

#include <QLayout>

void LineTitleGroupBox::paintEvent(QPaintEvent* event)
{
    Q_UNUSED(event);

    QStylePainter p(this);
    QStyleOptionGroupBox opt;
    initStyleOption(&opt);

    opt.subControls = QStyle::SC_GroupBoxLabel;
    p.drawComplexControl(QStyle::CC_GroupBox, opt);

    const QRect textRect =
        style()->subControlRect(QStyle::CC_GroupBox, &opt, QStyle::SC_GroupBoxLabel, this);

    const int y = textRect.bottom() + 4;
    auto borderColor =
        TokenParserWidgetManager::instance()->getColor(QLatin1String("border-strong"));
    p.setRenderHint(QPainter::Antialiasing, false);
    p.setPen(QPen(borderColor, 1));

    const QRect contentRect = contentsRect();
    int leftMargin = 0, rightMargin = 0;
    auto l = layout();
    if (l)
    {
        QMargins margins = l->contentsMargins();
        leftMargin = margins.left();
        rightMargin = margins.right();
    }
    p.drawLine(contentRect.left() + leftMargin, y, contentRect.right() - rightMargin, y);
}
