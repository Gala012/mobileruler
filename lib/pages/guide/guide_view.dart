import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobilem/components/common_widgets.dart';
import 'package:mobilem/lang/lang.dart';
import 'package:mobilem/pages/guide/guide_logic.dart';
import 'package:mobilem/utils/app_colors.dart';
import 'package:mobilem/utils/app_typography.dart';
import 'package:mobilem/utils/tool_icons.dart';

class GuideView extends StatefulWidget {
  const GuideView({super.key});

  @override
  State<GuideView> createState() => _GuideViewState();
}

class _GuideViewState extends State<GuideView> with AutomaticKeepAliveClientMixin {
  late final GuideLogic _logic;
  late final PageController _pageController;
  int _currentPage = 0;
  var _finishing = false;

  @override
  bool get wantKeepAlive => true;

  static const _pageCount = 3;

  final _items = const [
    _GuideItem(
      icon: ToolIcons.ruler,
      title: Lang.guideTitle1,
      desc: Lang.guideDesc1,
      accent: AppColors.cta,
      darkHero: true,
    ),
    _GuideItem(
      icon: Icons.apps_rounded,
      title: Lang.guideTitle2,
      desc: Lang.guideDesc2,
      accent: AppColors.primary,
      darkHero: false,
    ),
    _GuideItem(
      icon: Icons.offline_bolt_rounded,
      title: Lang.guideTitle3,
      desc: Lang.guideDesc3,
      accent: AppColors.cta,
      darkHero: false,
      badge: Lang.guideOffline,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _logic = Get.find<GuideLogic>();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isLastPage => _currentPage >= _pageCount - 1;

  Future<void> _finishGuide() async {
    if (_finishing || _logic.isFinishing) return;
    setState(() => _finishing = true);
    await _logic.markFinished();
  }

  void _onPrimaryAction() {
    if (_finishing) return;
    if (_isLastPage) {
      _finishGuide();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: _finishing ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  if (!mounted || _finishing) return;
                  setState(() => _currentPage = index);
                },
                itemCount: _pageCount,
                itemBuilder: (_, index) => _buildPage(_items[index], index),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(20),
        ScreenUtil().setHeight(8),
        ScreenUtil().setWidth(12),
        ScreenUtil().setHeight(4),
      ),
      child: Row(
        children: [
          Text(
            '${_currentPage + 1} / $_pageCount',
            style: AppTypography.label.copyWith(
              color: AppColors.textHint,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _finishing ? null : _finishGuide,
            child: Text(
              Lang.guideSkip,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(24),
        ScreenUtil().setHeight(12),
        ScreenUtil().setWidth(24),
        ScreenUtil().setHeight(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pageCount, (i) {
              final active = _currentPage == i;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(4)),
                width: active ? ScreenUtil().setWidth(22) : ScreenUtil().setWidth(7),
                height: ScreenUtil().setHeight(7),
                decoration: BoxDecoration(
                  color: active ? AppColors.cta : AppColors.divider,
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(4)),
                ),
              );
            }),
          ),
          SizedBox(height: ScreenUtil().setHeight(18)),
          PrimaryButton(
            label: _isLastPage ? Lang.guideStart : Lang.guideNext,
            icon: _isLastPage ? Icons.check_rounded : Icons.arrow_forward_rounded,
            onPressed: _finishing ? () {} : _onPrimaryAction,
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_GuideItem item, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
      child: Column(
        children: [
          SizedBox(height: ScreenUtil().setHeight(8)),
          Text(
            Lang.appName,
            style: AppTypography.label.copyWith(
              color: AppColors.textHint,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          Expanded(child: _buildHero(item, index)),
          SizedBox(height: ScreenUtil().setHeight(28)),
          Text(
            item.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.display.copyWith(fontSize: ScreenUtil().setSp(28)),
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Text(
            item.desc,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.55,
              fontSize: ScreenUtil().setSp(15),
            ),
          ),
          if (item.badge != null) ...[
            SizedBox(height: ScreenUtil().setHeight(12)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(12),
                vertical: ScreenUtil().setHeight(6),
              ),
              decoration: BoxDecoration(
                color: AppColors.cta.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
              ),
              child: Text(
                item.badge!,
                style: AppTypography.label.copyWith(
                  color: AppColors.ctaDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          SizedBox(height: ScreenUtil().setHeight(16)),
        ],
      ),
    );
  }

  Widget _buildHero(_GuideItem item, int index) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: item.darkHero ? AppColors.canvasDark : AppColors.cardBg,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ScreenUtil().radius(24)),
        child: switch (index) {
          0 => _RulerHero(accent: item.accent),
          1 => _ToolboxHero(accent: item.accent),
          _ => _ReadyHero(accent: item.accent, icon: item.icon),
        },
      ),
    );
  }
}

class _GuideItem {
  const _GuideItem({
    required this.icon,
    required this.title,
    required this.desc,
    required this.accent,
    required this.darkHero,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String desc;
  final Color accent;
  final bool darkHero;
  final String? badge;
}

class _RulerHero extends StatelessWidget {
  const _RulerHero({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: CustomPaint(painter: _RulerTicksPainter(accent: accent)),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ToolIcons.ruler, size: ScreenUtil().setSp(52), color: accent),
            SizedBox(height: ScreenUtil().setHeight(16)),
            Container(
              width: ScreenUtil().setWidth(180),
              height: ScreenUtil().setHeight(3),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.45),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RulerTicksPainter extends CustomPainter {
  _RulerTicksPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    for (var i = 0; i <= 12; i++) {
      final y = size.height * i / 12;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final edge = Paint()
      ..color = accent.withValues(alpha: 0.85)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), edge);
    for (var i = 0; i <= 8; i++) {
      final y = size.height * i / 8;
      final len = i % 2 == 0 ? 18.0 : 10.0;
      final tick = Paint()
        ..color = accent.withValues(alpha: 0.85)
        ..strokeWidth = i % 2 == 0 ? 2 : 1
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(0, y), Offset(len, y), tick);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ToolboxHero extends StatelessWidget {
  const _ToolboxHero({required this.accent});

  final Color accent;

  static const _icons = [
    ToolIcons.ruler,
    ToolIcons.protractor,
    ToolIcons.distance,
    ToolIcons.compass,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ScreenUtil().setWidth(28)),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: ScreenUtil().setHeight(14),
          crossAxisSpacing: ScreenUtil().setWidth(14),
        ),
        itemCount: _icons.length,
        itemBuilder: (_, index) {
          final featured = index == 0;
          return Container(
            decoration: BoxDecoration(
              color: featured ? AppColors.cta.withValues(alpha: 0.12) : AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
            ),
            child: Icon(
              _icons[index],
              color: featured ? AppColors.ctaDark : AppColors.primary,
              size: ScreenUtil().setSp(32),
            ),
          );
        },
      ),
    );
  }
}

class _ReadyHero extends StatelessWidget {
  const _ReadyHero({required this.accent, required this.icon});

  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.18),
            AppColors.surfaceMuted,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: ScreenUtil().setWidth(88),
            height: ScreenUtil().setWidth(88),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, size: ScreenUtil().setSp(44), color: accent),
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _miniChip(Icons.straighten_rounded),
              SizedBox(width: ScreenUtil().setWidth(10)),
              _miniChip(Icons.change_history_rounded),
              SizedBox(width: ScreenUtil().setWidth(10)),
              _miniChip(Icons.crop_free_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniChip(IconData data) {
    return Container(
      width: ScreenUtil().setWidth(40),
      height: ScreenUtil().setWidth(40),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
      ),
      child: Icon(data, size: ScreenUtil().setSp(20), color: AppColors.primary),
    );
  }
}
