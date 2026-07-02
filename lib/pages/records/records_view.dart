import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/bottom_sheet_helper.dart';
import 'package:mobilem/components/records_widgets.dart';
import 'package:mobilem/db_mobilem/db_mobilem_entity.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/records/records_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/stats_tool_meta.dart';

class _RecordListEntry {
  const _RecordListEntry.header(this.title) : record = null;
  const _RecordListEntry.item(this.record) : title = null;

  final String? title;
  final MeasurementRecordEntity? record;
}

class RecordsView extends GetView<RecordsLogic> {
  const RecordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.pageBg,
      child: SafeArea(
        child: Obx(() {
          final records = controller.records;
          final currentFilter = controller.filter.value;
          final sections = controller.sections;
          final entries = _flatten(sections);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: RecordsHeader(title: Lang.recordsTitle),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: ScreenUtil().setHeight(42),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
                    itemCount: controller.filters.length,
                    separatorBuilder: (_, __) => SizedBox(width: ScreenUtil().setWidth(8)),
                    itemBuilder: (_, index) {
                      final value = controller.filters[index];
                      return RecordsFilterChip(
                        label: controller.filterLabel(value),
                        selected: currentFilter == value,
                        icon: value.isEmpty ? null : StatsToolMeta.iconFor(value),
                        onTap: () => controller.setFilter(value),
                      );
                    },
                  ),
                ),
              ),
              if (records.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: RecordsEmptyCard(
                      title: Lang.recordsEmpty,
                      subtitle: Lang.recordsEmptyHint,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(16),
                    ScreenUtil().setHeight(4),
                    ScreenUtil().setWidth(16),
                    ScreenUtil().setHeight(20),
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildEntry(entries[index]),
                      childCount: entries.length,
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  List<_RecordListEntry> _flatten(List<RecordSection> sections) {
    final list = <_RecordListEntry>[];
    for (final section in sections) {
      list.add(_RecordListEntry.header(section.title));
      for (final record in section.items) {
        list.add(_RecordListEntry.item(record));
      }
    }
    return list;
  }

  Widget _buildEntry(_RecordListEntry entry) {
    if (entry.title != null) {
      return RecordsDateHeader(title: entry.title!);
    }

    final record = entry.record!;
    final id = record.id!;

    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
      child: Dismissible(
        key: ValueKey(id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          final result = await showConfirmSheet(message: Lang.confirmDelete);
          if (result == true) await controller.deleteRecord(id);
          return result == true;
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
          decoration: BoxDecoration(
            color: AppColors.danger,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(14)),
          ),
          child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
        ),
        child: RecordItemCard(
          toolName: Lang.toolTypeLabel(record.toolType),
          timeText: controller.timeLabel(record.createdAt),
          valueText: record.value.toStringAsFixed(2),
          unit: record.unit,
          icon: StatsToolMeta.iconFor(record.toolType),
          iconColor: StatsToolMeta.colorFor(record.toolType),
          note: record.note.isEmpty ? null : record.note,
          onTap: () => controller.openDetail(id),
        ),
      ),
    );
  }
}
