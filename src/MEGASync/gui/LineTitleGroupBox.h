#ifndef LINE_TITLE_GROUPBOX_H
#define LINE_TITLE_GROUPBOX_H

#include <QGroupBox>
#include <QPainter>
#include <QStyleOptionGroupBox>
#include <QStylePainter>

class LineTitleGroupBox: public QGroupBox
{
    Q_OBJECT

public:
    explicit LineTitleGroupBox(QWidget* parent = nullptr):
        QGroupBox(parent)
    {
        setFlat(true); // removes most native frame painting
    }

    explicit LineTitleGroupBox(const QString& title, QWidget* parent = nullptr):
        QGroupBox(title, parent)
    {
        setFlat(true);
    }

protected:
    void paintEvent(QPaintEvent* event) override;
};
#endif // LINE_TITLE_GROUPBOX_H
