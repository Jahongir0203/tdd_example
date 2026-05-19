import 'package:flutter/material.dart';
import 'package:tdd_example/core/theme/app_colors.dart';
import 'package:tdd_example/core/theme/app_text_styles.dart';
import 'package:tdd_example/features/comments/data/models/comment_model.dart';

class WCommentItem extends StatefulWidget {
  const WCommentItem({super.key, required this.comment});

  final CommentModel comment;

  @override
  State<WCommentItem> createState() => _WCommentItemState();
}

class _WCommentItemState extends State<WCommentItem> {
  var isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 6),
      child: Column(
        spacing: 8,
        crossAxisAlignment: .start,
        children: [
          Row(
            spacing: 12,
            children: [
              Container(
                height: 50,
                width: 50,
                alignment: .center,
                decoration: BoxDecoration(
                  color: AppColors.cBlueGrey,
                  borderRadius: .circular(50),
                ),
                child: Icon(Icons.person_2, color: AppColors.cWhite, size: 30),
              ),
              Expanded(
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: .start,
                  children: [
                    Text(widget.comment.name, style: AppTextStyles.size16Bold),
                    Text(
                      widget.comment.email,
                      style: AppTextStyles.size14Medium.copyWith(
                        color: AppColors.cGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: isSelected,
                onChanged: (v) => setState(() => isSelected = !isSelected),
                activeColor: AppColors.cBlueAccent,
              ),
            ],
          ),
          Text(
            widget.comment.body,
            style: AppTextStyles.size14Regular.copyWith(
              color: AppColors.cBlack,
            ),
          ),
        ],
      ),
    );
  }
}
