import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/app_chrome.dart';
import 'package:mobilem/components/secondary_page_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/unit_converter/unit_converter_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_decorations.dart';
import 'package:mobilem/utils/app_typography.dart';

class UnitConverterView extends GetView<UnitConverterLogic> {
  const UnitConverterView({super.key});

  static const _gridColumns = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: SecondaryAppBar(
        title: Lang.unitConverterTitle,
        actions: [
          AppBarIconAction(
            icon: Icons.swap_vert_rounded,
            dark: false,
            onPressed: controller.swapUnits,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(14),
            ScreenUtil().setHeight(4),
            ScreenUtil().setWidth(14),
            ScreenUtil().setHeight(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputCard(),
              SizedBox(height: ScreenUtil().setHeight(8)),
              Obx(() => _buildUnitsCard()),
              SizedBox(height: ScreenUtil().setHeight(8)),
              Obx(() => _buildResultCard()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(12),
        ScreenUtil().setHeight(8),
        ScreenUtil().setWidth(12),
        ScreenUtil().setHeight(10),
      ),
      decoration: AppDecorations.shadowCard(radius: 12, shadowOpacity: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Lang.unitConverterInput,
            style: AppTypography.label,
          ),
          SizedBox(height: ScreenUtil().setHeight(6)),
          TextField(
            controller: controller.inputController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppTypography.metric.copyWith(fontSize: ScreenUtil().setSp(26)),
            decoration: InputDecoration(
              hintText: '0',
              isDense: true,
              filled: true,
              fillColor: AppColors.surfaceMuted,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(10),
                vertical: ScreenUtil().setHeight(8),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                borderSide: const BorderSide(color: AppColors.cta, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitsCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(10),
        ScreenUtil().setHeight(8),
        ScreenUtil().setWidth(10),
        ScreenUtil().setHeight(8),
      ),
      decoration: AppDecorations.shadowCard(radius: 12, shadowOpacity: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildUnitGrid(
            title: Lang.unitConverterFrom,
            selected: controller.fromUnit.value,
            onSelect: controller.setFromUnit,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(4)),
            child: Divider(height: 1, color: AppColors.divider),
          ),
          _buildUnitGrid(
            title: Lang.unitConverterTo,
            selected: controller.toUnit.value,
            onSelect: controller.setToUnit,
          ),
        ],
      ),
    );
  }

  Widget _buildUnitGrid({
    required String title,
    required String selected,
    required ValueChanged<String> onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(2),
            bottom: ScreenUtil().setHeight(6),
          ),
          child: Text(
            title,
            style: AppTypography.title.copyWith(fontSize: ScreenUtil().setSp(14)),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _gridColumns,
            mainAxisSpacing: ScreenUtil().setHeight(4),
            crossAxisSpacing: ScreenUtil().setWidth(4),
            childAspectRatio: 1.12,
          ),
          itemCount: UnitConverterLogic.units.length,
          itemBuilder: (_, index) {
            final unit = UnitConverterLogic.units[index];
            return _UnitChip(
              code: unit,
              name: controller.unitShortName(unit),
              selected: selected == unit,
              onTap: () => onSelect(unit),
            );
          },
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(16),
        vertical: ScreenUtil().setHeight(14),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Lang.unitConverterResult,
                  style: AppTypography.label.copyWith(color: Colors.white60),
                ),
                SizedBox(height: ScreenUtil().setHeight(4)),
                Text(
                  controller.unitLabel(controller.toUnit.value),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          Text(
            controller.resultText,
            style: AppTypography.metric.copyWith(
              fontSize: ScreenUtil().setSp(32),
              color: AppColors.cta,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitChip extends StatelessWidget {
  const _UnitChip({
    required this.code,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(6),
            vertical: ScreenUtil().setHeight(6),
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.cta.withValues(alpha: 0.12) : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
            border: Border.all(
              color: selected ? AppColors.cta : AppColors.divider,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      code,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: ScreenUtil().setSp(14),
                        color: selected ? AppColors.ctaDark : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: ScreenUtil().setWidth(16),
                    height: ScreenUtil().setWidth(16),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.cta : Colors.transparent,
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(4)),
                      border: Border.all(
                        color: selected ? AppColors.cta : AppColors.borderStrong,
                        width: 1.5,
                      ),
                    ),
                    child: selected
                        ? Icon(Icons.check_rounded, size: ScreenUtil().setSp(12), color: AppColors.primary)
                        : null,
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(2)),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.label.copyWith(
                  fontSize: ScreenUtil().setSp(11),
                  color: selected ? AppColors.ctaDark : AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
