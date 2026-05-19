import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_example/features/comments/data/models/comment_model.dart';
import 'package:tdd_example/features/comments/domain/repository/comments_repository.dart';
import 'package:tdd_example/features/comments/presentation/cubits/comments_cubit/comments_cubit.dart';
import 'package:tdd_example/features/comments/presentation/pages/comments_page/widgets/widgets.dart';

class MockCommentsRepository extends Mock implements CommentsRepository {}

final tComment = CommentModel(
  id: 1,
  postId: 1,
  name: 'John Doe',
  email: 'john@example.com',
  body: 'Test body text',
);

void main() {
  late MockCommentsRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });
  setUp(() {
    mockRepository = MockCommentsRepository();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CommentsCubit(mockRepository)..getComments(),
        child: Scaffold(body: WCommentsBody()),
      ),
    );
  }

  group('Commentspage - loading holati', () {
    testWidgets("getComments loading bo'lsa Skeleton ko'rinishi kerak", (
      tester,
    ) async {
      // Completer — Future'ni biz xohlaganda resolve qilamiz
      final completer = Completer<Either<dynamic, List<CommentModel>>>();

      when(
        () => mockRepository.getComments(
          cacheDuration: any(named: 'cacheDuration'),
        ),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      // ✅ Shu paytda Skeleton ko'rinishi kerak
      expect(find.byType(WCommentSkeletonizerItem), findsWidgets);

      // Cleanup: Future'ni resolve qilib, test to'g'ri tugasin
      completer.complete(Right([]));
      await tester.pumpAndSettle();
    });
  });
}
