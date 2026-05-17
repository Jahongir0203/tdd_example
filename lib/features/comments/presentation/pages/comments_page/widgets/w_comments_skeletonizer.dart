import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tdd_example/core/theme/app_colors.dart';
import 'package:tdd_example/core/theme/app_text_styles.dart';

class WCommentSkeletonizerItem extends StatefulWidget {
  const WCommentSkeletonizerItem({super.key});

  @override
  State<WCommentSkeletonizerItem> createState() =>
      _WCommentSkeletonizerItemState();
}

class _WCommentSkeletonizerItemState extends State<WCommentSkeletonizerItem> {
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const .symmetric(vertical: 6),
        child: Column(
          spacing: 8,
          crossAxisAlignment: .start,
          children: [
            Row(
              spacing: 12,
              children: [
                ClipRRect(
                  borderRadius: .circular(50),
                  child: Container(
                    height: 50,
                    width: 50,
                    color: AppColors.cBlack,
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: .start,
                    children: [
                      Text('Johs Smith', style: AppTextStyles.size16Bold),
                      Text(
                        'Life is good',
                        style: AppTextStyles.size14Medium.copyWith(
                          color: AppColors.cGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 20, width: 20, color: AppColors.cBlack),
              ],
            ),
            Text(
              'laudantium enim quasi est quidem magnam voluptate ipsam eos tempora quo necessitatibus dolor quam autem quasi reiciendis et nam sapiente accusantium',
              style: AppTextStyles.size14Regular.copyWith(
                color: AppColors.cBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
