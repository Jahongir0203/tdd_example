import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_example/core/network/dio_client.dart';
import 'package:tdd_example/features/comments/data/datasource/comments_datasource.dart';
import 'package:tdd_example/features/comments/data/models/comment_model.dart';

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockDioClient mockDioClient;
  late MockDio mockDio;
  late CommentsDatasourceImpl datasourceImpl;
  const tDuration = Duration(hours: 1);

  final tJsonList = [
    {
      'postId': 1,
      'id': 1,
      'name': 'Alice',
      'email': 'alice@test.com',
      'body': 'Hello',
    },
    {
      'postId': 2,
      'id': 2,
      'name': 'Bob',
      'email': 'bob@test.com',
      'body': 'World',
    },
  ];

  final tComments = [
    const CommentModel(
      postId: 1,
      id: 1,
      name: 'Alice',
      email: 'alice@test.com',
      body: 'Hello',
    ),
    const CommentModel(
      postId: 2,
      id: 2,
      name: 'Bob',
      email: 'bob@test.com',
      body: 'World',
    ),
  ];
  setUp(() {
    mockDioClient = MockDioClient();
    mockDio = MockDio();
    datasourceImpl = CommentsDatasourceImpl(mockDioClient);

    when(
      () => mockDioClient.client(cacheDuration: any(named: 'cacheDuration')),
    ).thenReturn(mockDio);
  });

  group('Commentsdatasource test', () {
    test(
      'get comments - success: to\'g\'ri parse qilib Right qiladi!',
      () async {
        when(() => mockDio.get('/comments')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/comments'),
            data: tJsonList,
            statusCode: 200,
          ),
        );
        final result = await datasourceImpl.getComments(
          cacheDuration: tDuration,
        );

        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (comments) => expect(comments, equals(tComments)),
        );

        //expect(result, equals(Right<dynamic, List<CommentModel>>(tComments)));
        verify(() => mockDio.get('/comments')).called(1);
      },
    );

    test('getComments- fail, DioException bo\'lsa Left qaytaradi!', () async {
      when(() => mockDio.get('/comments')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/comments'),
          type: DioExceptionType.connectionError,
          message: 'Internet mavjud emas',
        ),
      );
      final result = await datasourceImpl.getComments(cacheDuration: tDuration);

      expect(result.isLeft(), isTrue);
    });

    test('clear-dioClient.clearCache() chaqirilinadi', () async {
      when(() => mockDioClient.clearCache()).thenAnswer((_) async {});
      await datasourceImpl.clear();
      verify(() => mockDioClient.clearCache()).called(1);
    });
  });
}
