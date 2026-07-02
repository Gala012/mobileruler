import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/home_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/tools/tools_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';

class ToolsView extends GetView<ToolsLogic> {
  const ToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.pageBg,
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(16),
                ScreenUtil().setHeight(12),
                ScreenUtil().setWidth(16),
                ScreenUtil().setHeight(16),
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: ScreenUtil().setHeight(12),
                  crossAxisSpacing: ScreenUtil().setWidth(12),
                  childAspectRatio: 1.55,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    final tool = ToolsLogic.allTools[index];
                    return ToolGridTile(
                      title: tool.title,
                      icon: tool.icon,
                      featured: tool.featured,
                      onTap: () => controller.openTool(tool),
                    );
                  },
                  childCount: ToolsLogic.allTools.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(8),
        ScreenUtil().setWidth(16),
        ScreenUtil().setHeight(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Lang.appName,
                  style: AppTypography.label.copyWith(
                    color: AppColors.textHint,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(4)),
                Text(
                  Lang.toolsTitle,
                  style: AppTypography.display.copyWith(fontSize: ScreenUtil().setSp(30)),
                ),
              ],
            ),
          ),
          Obx(() {
            final count = controller.totalMeasurements.value;
            if (count <= 0) return const SizedBox.shrink();
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(12),
                vertical: ScreenUtil().setHeight(6),
              ),
              decoration: BoxDecoration(
                color: AppColors.cta.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
              ),
              child: Text(
                '$count ${Lang.statsTimes}',
                style: AppTypography.label.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: ScreenUtil().setSp(11),
                  color: AppColors.ctaDark,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
