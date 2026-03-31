#include "AccountStateQuickWidget.h"

#include "control/TextDecorator.h"

#include <QQmlContext>

namespace
{
QString decorateTooltipText(const QString& text)
{
    auto decoratedText = text;
    Text::NewLine().process(decoratedText);
    return decoratedText;
}
}

AccountStateQuickWidget::AccountStateQuickWidget(QWidget* parent):
    MegaQuickWidget(parent)
{
    rootContext()->setContextProperty(QString::fromLatin1("accountStateAccess"), this);
    setResizeMode(QQuickWidget::SizeRootObjectToView);
    setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
    setSource(QString::fromUtf8("qrc:/settings/AccountStateSurface.qml"));
}

bool AccountStateQuickWidget::showStorageCard() const
{
    return mShowStorageCard;
}

bool AccountStateQuickWidget::showTransferCard() const
{
    return mShowTransferCard;
}

QString AccountStateQuickWidget::storageSummary() const
{
    return mStorageSummary;
}

QString AccountStateQuickWidget::storageFreeText() const
{
    return mStorageFreeText;
}

QString AccountStateQuickWidget::storageFreeTooltipText() const
{
    return mStorageFreeTooltipText;
}

int AccountStateQuickWidget::storagePercentage() const
{
    return mStoragePercentage;
}

int AccountStateQuickWidget::storageState() const
{
    return mStorageState;
}

QVariantList AccountStateQuickWidget::storageSegments() const
{
    return mStorageSegments;
}

bool AccountStateQuickWidget::storageUsageOnly() const
{
    return mStorageUsageOnly;
}

QString AccountStateQuickWidget::transferSummary() const
{
    return mTransferSummary;
}

QString AccountStateQuickWidget::transferFreeText() const
{
    return mTransferFreeText;
}

QString AccountStateQuickWidget::transferFreeTooltipText() const
{
    return mTransferFreeTooltipText;
}

int AccountStateQuickWidget::transferPercentage() const
{
    return mTransferPercentage;
}

int AccountStateQuickWidget::transferState() const
{
    return mTransferState;
}

QVariantList AccountStateQuickWidget::transferSegments() const
{
    return mTransferSegments;
}

bool AccountStateQuickWidget::transferValueOnly() const
{
    return mTransferValueOnly;
}

QString AccountStateQuickWidget::transferValueText() const
{
    return mTransferValueText;
}

void AccountStateQuickWidget::setShowStorageCard(bool showStorageCard)
{
    if (mShowStorageCard == showStorageCard)
    {
        return;
    }

    mShowStorageCard = showStorageCard;
    emit showStorageCardChanged();
}

void AccountStateQuickWidget::setShowTransferCard(bool showTransferCard)
{
    if (mShowTransferCard == showTransferCard)
    {
        return;
    }

    mShowTransferCard = showTransferCard;
    emit showTransferCardChanged();
}

void AccountStateQuickWidget::setStorageData(const QString& summary,
                                             const QString& freeText,
                                             int percentage,
                                             ProgressState state,
                                             const QVariantList& segments,
                                             bool usageOnly)
{
    if (mStorageSummary != summary)
    {
        mStorageSummary = summary;
        emit storageSummaryChanged();
    }

    const auto tooltipText =
        freeText.isEmpty() ? QString() : decorateTooltipText(tr("Available[BR]%1").arg(freeText));
    if (mStorageFreeText != freeText)
    {
        mStorageFreeText = freeText;
        emit storageFreeTextChanged();
    }
    if (mStorageFreeTooltipText != tooltipText)
    {
        mStorageFreeTooltipText = tooltipText;
        emit storageFreeTooltipTextChanged();
    }
    if (mStoragePercentage != percentage)
    {
        mStoragePercentage = percentage;
        emit storagePercentageChanged();
    }
    if (mStorageState != state)
    {
        mStorageState = state;
        emit storageStateChanged();
    }
    if (mStorageSegments != segments)
    {
        mStorageSegments = segments;
        emit storageSegmentsChanged();
    }
    if (mStorageUsageOnly != usageOnly)
    {
        mStorageUsageOnly = usageOnly;
        emit storageUsageOnlyChanged();
    }
}

void AccountStateQuickWidget::setTransferData(const QString& summary,
                                              const QString& freeText,
                                              int percentage,
                                              ProgressState state,
                                              const QVariantList& segments,
                                              bool valueOnly,
                                              const QString& valueText)
{
    if (mTransferSummary != summary)
    {
        mTransferSummary = summary;
        emit transferSummaryChanged();
    }

    const auto tooltipText =
        freeText.isEmpty() ? QString() : decorateTooltipText(tr("Available[BR]%1").arg(freeText));
    if (mTransferFreeText != freeText)
    {
        mTransferFreeText = freeText;
        emit transferFreeTextChanged();
    }
    if (mTransferFreeTooltipText != tooltipText)
    {
        mTransferFreeTooltipText = tooltipText;
        emit transferFreeTooltipTextChanged();
    }
    if (mTransferPercentage != percentage)
    {
        mTransferPercentage = percentage;
        emit transferPercentageChanged();
    }
    if (mTransferState != state)
    {
        mTransferState = state;
        emit transferStateChanged();
    }
    if (mTransferSegments != segments)
    {
        mTransferSegments = segments;
        emit transferSegmentsChanged();
    }
    if (mTransferValueOnly != valueOnly)
    {
        mTransferValueOnly = valueOnly;
        emit transferValueOnlyChanged();
    }
    if (mTransferValueText != valueText)
    {
        mTransferValueText = valueText;
        emit transferValueTextChanged();
    }
}
