import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/secondary_page_widgets.dart';
import 'package:mobilem/components/stats_charts.dart';
import 'package:mobilem/components/stats_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/stats/stats_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';
import 'package:mobilem/utils/stats_tool_meta.dart';

class StatsView extends GetView<StatsLogic> {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: SecondaryAppBar(title: Lang.statsTitle),
      body: Obx(() {
        final topTool = controller.topTool;
        final maxUsage = controller.maxUsage();
        final nextTarget = controller.nextBadgeTarget;

        return ListView(
          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
          children: [
            StatsSectionTitle(title: Lang.statsOverview, icon: Icons.insights_rounded),
            Row(
              children: [
                Expanded(
                  child: StatsMetricCard(
                    icon: Icons.analytics_outlined,
                    label: Lang.statsTotal,
                    value: '${controller.total.value}',
                    unit: Lang.statsTimes,
                    iconColor: AppColors.cta,
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(12)),
                Expanded(
                  child: StatsMetricCard(
                    icon: Icons.calendar_today_rounded,
                    label: Lang.statsActive7d,
                    value: '${controller.activeDays.value}',
                    unit: Lang.statsTimes,
                    iconColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(12)),
            StatsMetricCard(
              icon: Icons.apps_rounded,
              label: Lang.statsToolsUsed,
              value: '${controller.toolsUsedCount}',
              unit: Lang.statsKinds,
              iconColor: AppColors.secondary,
            ),
            SizedBox(height: ScreenUtil().setHeight(24)),
            StatsSectionTitle(title: Lang.statsTrend7d, icon: Icons.show_chart_rounded),
            StatsTrendBarChart(items: controller.dailyTrend.toList()),
            if (nextTarget != null) ...[
              SizedBox(height: ScreenUtil().setHeight(24)),
              StatsAchievementGauge(
                current: controller.total.value,
                nextTarget: nextTarget,
                progress: controller.nextBadgeProgress,
              ),
            ],
            if (topTool != null) ...[
              SizedBox(height: ScreenUtil().setHeight(24)),
              StatsSectionTitle(title: Lang.statsTopTool, icon: Icons.star_rounded),
              StatsHighlightCard(
                title: Lang.statsTopTool,
                toolName: Lang.toolTypeLabel(topTool.toolType),
                count: topTool.useCount,
                icon: StatsToolMeta.iconFor(topTool.toolType),
                iconColor: StatsToolMeta.colorFor(topTool.toolType),
              ),
            ],
            SizedBox(height: ScreenUtil().setHeight(24)),
            StatsSectionTitle(title: Lang.statsDistribution, icon: Icons.donut_large_rounded),
            if (controller.distributionSegments.isEmpty)
              const StatsEmptyCard(
                icon: Icons.pie_chart_outline_rounded,
                message: Lang.recordsEmpty,
              )
            else
              StatsDonutChart(
                segments: controller.distributionSegments,
                centerLabel: Lang.statsTotal,
                centerValue: '${controller.usageTotal}',
              ),
            SizedBox(height: ScreenUtil().setHeight(24)),
            StatsSectionTitle(title: Lang.statsToolUsage, icon: Icons.leaderboard_rounded),
            if (controller.usageStats.isEmpty)
              const StatsEmptyCard(
                icon: Icons.bar_chart_rounded,
                message: Lang.recordsEmpty,
              )
            else
              ...List.generate(controller.usageStats.length, (index) {
                final stat = controller.usageStats[index];
                return StatsUsageCard(
                  rank: index + 1,
                  toolName: Lang.toolTypeLabel(stat.toolType),
                  count: stat.useCount,
                  ratio: stat.useCount / maxUsage,
                  icon: StatsToolMeta.iconFor(stat.toolType),
                  iconColor: StatsToolMeta.colorFor(stat.toolType),
                );
              }),
            SizedBox(height: ScreenUtil().setHeight(24)),
            Row(
              children: [
                Expanded(
                  child: StatsSectionTitle(
                    title: Lang.statsBadges,
                    icon: Icons.military_tech_rounded,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(10),
                    vertical: ScreenUtil().setHeight(4),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cta.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, size: ScreenUtil().setSp(14), color: AppColors.ctaDark),
                      SizedBox(width: ScreenUtil().setWidth(4)),
                      Text(
                        '${controller.unlockedBadgeCount}/${controller.allBadges.length}',
                        style: AppTypography.label.copyWith(
                          color: AppColors.ctaDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ...controller.allBadges.map((badge) {
              final unlocked = controller.isUnlocked(badge.$1);
              return StatsBadgeCard(
                title: badge.$2,
                target: badge.$3,
                progress: controller.badgeProgress(badge.$3),
                unlocked: unlocked,
              );
            }),
            SizedBox(height: ScreenUtil().setHeight(8)),
          ],
        );
      }),
    );
  }
}
