import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_example/core/helpers/enum_helpers.dart';
import 'package:tdd_example/core/theme/app_colors.dart';
import 'package:tdd_example/core/theme/app_text_styles.dart';
import 'package:tdd_example/features/comments/presentation/cubits/comments_cubit/comments_cubit.dart';
import 'widgets.dart';

class WCommentsBody extends StatelessWidget {
  const WCommentsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsCubit, CommentsState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (BuildContext context, CommentsState state) {
        final cubit = context.read<CommentsCubit>();
        final status = state.status;
        if (status.isFail) {
          return Center(
            child: Column(
              spacing: 12,
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                Icon(Icons.error, color: AppColors.cRed, size: 40),
                Text(state.error, style: AppTextStyles.size14Medium),
              ],
            ),
          );
        }

        if (status.isSuccess) {
          return ListView.separated(
            padding: .all(16),
            shrinkWrap: true,
            itemBuilder: (_, i) {
              return WCommentItem();
            },
            separatorBuilder: (_, i) => Divider(),
            itemCount: 10,
          );
        }

        return ListView.separated(
          padding: .all(16),
          shrinkWrap: true,
          itemBuilder: (_, i) {
            return WCommentSkeletonizerItem();
          },
          separatorBuilder: (_, i) => Divider(),
          itemCount: 10,
        );
      },
    );
  }
}
