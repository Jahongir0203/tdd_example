import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:tdd_example/core/di/di.dart';
import 'package:tdd_example/features/comments/presentation/cubits/comments_cubit/comments_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/widgets.dart';

@RoutePage()
class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<CommentsCubit>()..getComments(),
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('Comments')),
        body: WCommentsBody(),
      ),
    );
  }
}
