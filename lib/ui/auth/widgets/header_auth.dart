import 'package:flutter/material.dart';
import 'package:synamyk/ui/core/ui/themes/app_colors.dart';
import 'package:synamyk/ui/core/ui/themes/app_text_styles.dart';

class HeaderAuth {
  static List<Widget> slivers(
    BuildContext context,
    Text title,
    String subtitle,
    String image,
  ) {
    final canPop = Navigator.of(context).canPop();
    return [
      SliverAppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: canPop
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
      ),

      SliverToBoxAdapter(
        child: Center(
          child: Container(
            width: 104,
            height: 104,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: AppColors.cardShadow,
            ),
            child: Image.asset(image, fit: BoxFit.contain),
          ),
        ),
      ),

      const SliverToBoxAdapter(child: SizedBox(height: 28)),

      SliverToBoxAdapter(
        child: Column(
          spacing: 10,
          children: [
            Text(
              title.data ?? '',
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),

      const SliverToBoxAdapter(child: SizedBox(height: 32)),
    ];
  }
}
