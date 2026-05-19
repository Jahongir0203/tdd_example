import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_example/core/helpers/enum_helpers.dart';
import 'package:tdd_example/features/comments/data/models/comment_model.dart';
import 'package:tdd_example/features/comments/domain/repository/comments_repository.dart';
import 'package:tdd_example/features/comments/presentation/cubits/comments_cubit/comments_cubit.dart';

final class MockCommentsRepository extends Mock implements CommentsRepository {}

void main() {
  late MockCommentsRepository mockRepository;
  late CommentsCubit cubit;

  setUp(() {
    mockRepository = MockCommentsRepository();
    cubit = CommentsCubit(mockRepository);
  });

  tearDown(() => cubit.close());

  final tComments = [
    CommentModel(
      id: 1,
      postId: 42,
      name: 'John Doe',
      email: 'john@example.com',
      body: 'Hello World!',
    ),
    CommentModel(
      id: 2,
      postId: 72,
      name: 'Tom Mark',
      email: 'tomn@example.com',
      body: 'This is UNIT test for cubit',
    ),
  ];

  const tDuration = Duration(hours: 1);

  group('CommentsCubit UNIT test', () {
    test('Initial state to\'g\'ri!', () {
      expect(cubit.state.status, equals(RequestStatus.initial));
      expect(cubit.state.comments, isEmpty);
    });
    // success state
    blocTest<CommentsCubit, CommentsState>(
      'getComments-success: loadingdan keyin success emit qilinadi!',
      build: () {
        when(
          () => mockRepository.getComments(cacheDuration: tDuration),
        ).thenAnswer((_) async => Right(tComments));
        return cubit;
      },
      act: (cubit) => cubit.getComments(),
      expect: () => [
        isA<CommentsState>().having(
          (p0) => p0.status,
          'status',
          RequestStatus.loading,
        ),
        isA<CommentsState>()
            .having((p0) => p0.status, 'status', RequestStatus.success)
            .having((p0) => p0.comments, 'comments', tComments),
      ],
    );
    // fail state
    blocTest<CommentsCubit, CommentsState>(
      'getComments- fail: loadingdan keyin fail emit qilinadi!',
      build: () {
        when(
          () => mockRepository.getComments(cacheDuration: tDuration),
        ).thenAnswer((_) async => Left('Server xatosi'));
        return cubit;
      },
      act: (cubit) => cubit.getComments(),
      expect: () => [
        isA<CommentsState>().having(
          (p0) => p0.status,
          'status',
          RequestStatus.loading,
        ),
        isA<CommentsState>()
            .having((p0) => p0.status, 'status', RequestStatus.fail)
            .having((p0) => p0.error, 'error', 'Server xatosi'),
      ],
    );

    // refresh

    blocTest(
      'refresh-clear chaqirib getComments qiladi!',
      build: () {
        when(() => mockRepository.clear()).thenAnswer((_) async {});
        when(
          () => mockRepository.getComments(cacheDuration: tDuration),
        ).thenAnswer((_) async => Right(tComments));
        return cubit;
      },
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<CommentsState>().having(
          (s) => s.status,
          'status',
          RequestStatus.loading,
        ),
        isA<CommentsState>()
            .having((s) => s.status, 'status', RequestStatus.success)
            .having((s) => s.comments, 'comments', tComments),
      ],
      verify: (cubit) {
        verify(() => mockRepository.clear()).called(1);
      },
    );
  });
}
