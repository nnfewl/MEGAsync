#ifndef TRAYICONMANAGER_H
#define TRAYICONMANAGER_H

#include <QIcon>
#include <QMap>
#include <QObject>
#include <QString>
#include <QSystemTrayIcon>
#include <QTimer>
#include <QVector>

#ifdef Q_OS_LINUX
#include <QDBusConnection>
#include <QDBusMessage>
#include <QDBusVariant>
#endif

class TrayIconManager: public QObject
{
    Q_OBJECT

public:
    enum class Theme
    {
        Dark,
        Light
    };

    enum class Animation
    {
        Progress, // tray_icon_progress_frame_1..30.svg
        Logging, // tray_icon_logging_frame_1..N.svg
        Promo, // tray_icon_offer_frame_1..N.svg
        None
    };

    explicit TrayIconManager(QObject* parent = nullptr);
    ~TrayIconManager() override;

    /** Create the QSystemTrayIcon and load resources. Call once. */
    void initTrayIcon();

    void setIcon(const QString& stateName);
    void setIconAndTooltip(const QString& stateName, const QString& tooltip);

    void startAnimation(Animation animation);
    void stopAnimation();
    bool isAnimating() const;

    void setTooltip(const QString& tooltip);

    void updateTheme();
    Theme theme() const;

    QSystemTrayIcon* trayIcon() const;

    void show();
    void hide();

signals:
    void activated(QSystemTrayIcon::ActivationReason reason);
    void messageClicked();

private slots:
    void onAnimationStep();

private:
    struct AnimationDef
    {
        const char* filenameTemplate; // printf-style, %1 = frame number
        int frameCount;
        int intervalMs;
    };

    void loadIcons();
    void applyIcon(const QIcon& icon);
    void applyCurrentStaticIcon();
    QIcon loadIcon(const QString& filename) const;
    QString themePrefix() const;
#ifdef Q_OS_LINUX
    void setDBusIconName(const QString& stateName);
#endif

    QSystemTrayIcon* mTrayIcon = nullptr;
    QMap<QString, QIcon> mStaticIcons;
    QMap<Animation, QVector<QIcon>> mAnimationFrameSets;
    QTimer* mAnimationTimer = nullptr;
    int mAnimationIndex = 0;
    QString mCurrentStateName;
    Animation mCurrentAnimation = Animation::Progress;
    Theme mTheme = Theme::Dark;

    static const AnimationDef ANIMATION_DEFS[];
};

#endif // TRAYICONMANAGER_H
