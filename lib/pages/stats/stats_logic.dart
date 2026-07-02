import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/stats_charts.dart';
import 'package:mobilem/db_mobilem/db_mobilem_entity.dart';
import 'package:mobilem/db_mobilem/db_mobilem_helper.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/utils/app_colors.dart';

class StatsLogic extends GetxController {
  final total = 0.obs;
  final activeDays = 0.obs;
  final usageStats = <UsageStatEntity>[].obs;
  final badges = <AchievementBadgeEntity>[].obs;
  final dailyTrend = <MapEntry<String, int>>[].obs;

  final allBadges = const [
    ('badge_10', Lang.badge10, 10),
    ('badge_50', Lang.badge50, 50),
    ('badge_100', Lang.badge100, 100),
  ];

  static const _chartColors = [
    AppColors.cta,
    AppColors.primary,
    AppColors.secondary,
    AppColors.success,
    Color(0xFF737373),
    Color(0xFFB8962E),
  ];

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    total.value = await DbMobilemHelper.instance.getTotalMeasurements();
    activeDays.value = await DbMobilemHelper.instance.getRecentActiveDays();
    usageStats.value = await DbMobilemHelper.instance.getUsageStats();
    badges.value = await DbMobilemHelper.instance.getBadges();
    dailyTrend.value = await DbMobilemHelper.instance.getDailyMeasurementTrend();
  }

  bool isUnlocked(String key) => badges.any((b) => b.badgeKey == key);

  int get toolsUsedCount => usageStats.length;

  int get unlockedBadgeCount => allBadges.where((b) => isUnlocked(b.$1)).length;

  UsageStatEntity? get topTool => usageStats.isEmpty ? null : usageStats.first;

  int maxUsage() {
    if (usageStats.isEmpty) return 1;
    return usageStats.map((e) => e.useCount).reduce((a, b) => a > b ? a : b);
  }

  double badgeProgress(int threshold) {
    if (threshold <= 0) return 0;
    return (total.value / threshold).clamp(0.0, 1.0);
  }

  int? get nextBadgeTarget {
    for (final badge in allBadges) {
      if (!isUnlocked(badge.$1)) return badge.$3;
    }
    return null;
  }

  double get nextBadgeProgress {
    final target = nextBadgeTarget;
    if (target == null) return 1;
    return badgeProgress(target);
  }

  List<StatsChartSegment> get distributionSegments {
    if (usageStats.isEmpty) return [];

    const maxSlices = 5;
    final sorted = List<UsageStatEntity>.from(usageStats);
    final top = sorted.take(maxSlices).toList();
    final otherCount = sorted.skip(maxSlices).fold<int>(0, (sum, e) => sum + e.useCount);

    final segments = <StatsChartSegment>[];
    for (var i = 0; i < top.length; i++) {
      segments.add(
        StatsChartSegment(
          label: Lang.toolTypeLabel(top[i].toolType),
          value: top[i].useCount,
          color: _chartColors[i % _chartColors.length],
        ),
      );
    }
    if (otherCount > 0) {
      segments.add(
        StatsChartSegment(
          label: Lang.statsOther,
          value: otherCount,
          color: AppColors.textHint,
        ),
      );
    }
    return segments;
  }

  int get usageTotal => usageStats.fold<int>(0, (sum, e) => sum + e.useCount);
}
