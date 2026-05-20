import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_example/features/comments/data/datasource/comments_datasource.dart';
import 'package:tdd_example/features/comments/data/models/comment_model.dart';

class MockCommentsDatasource extends Mock implements CommentsDatasource {}

void main() {
  late MockCommentsDatasource mockDatasource;


  setUp(() {
    mockDatasource = MockCommentsDatasource();
  });

  final tComments = [
    CommentModel(
      id: 1,
      postId: 18,
      name: 'Mark Jen',
      email: 't@t.com',
      body: 'Hey, flutter devs!',
    ),
  ];
  const tDuration = Duration(hours: 1);

  group('CommentsRepositoryImpl test', () {
    test(
      'getComments-datasource natijasini to\'g\'ridan to\'g\'ri qaytaradi!',
      () async {
        when(
          () => mockDatasource.getComments(cacheDuration: tDuration),
        ).thenAnswer((_) async => Right(tComments));
        final result = await mockDatasource.getComments(
          cacheDuration: tDuration,
        );
        expect(result, equals(Right<dynamic, List<CommentModel>>(tComments)));
        verify(
          () => mockDatasource.getComments(cacheDuration: tDuration),
        ).called(1);
      },
    );
  });
}
