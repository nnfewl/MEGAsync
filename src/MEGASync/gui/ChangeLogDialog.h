#ifndef CHANGELOGDIALOG_H
#define CHANGELOGDIALOG_H

#include <QDialog>
#include <QPixmap>

namespace Ui {
class ChangeLogDialog;
}

class ChangeLogDialog : public QDialog
{
    Q_OBJECT

public:
    explicit ChangeLogDialog(QString version, QString SDKversion, QString changeLog, QWidget *parent = 0);
    ~ChangeLogDialog();

private:
    Ui::ChangeLogDialog *ui;
    QPixmap mHeaderBackground;

    void setChangeLogNotes(QString notes);

protected:
    bool event(QEvent* event) override;
    bool eventFilter(QObject* obj, QEvent* event) override;
    void tweakStrings();

private slots:
    void on_bTerms_clicked();
    void on_bPolicy_clicked();
    void on_bAck_clicked();
};

#endif // CHANGELOGDIALOG_H
