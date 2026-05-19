import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tdd_example/core/helpers/error_handler.dart';
import 'package:tdd_example/core/network/dio_client.dart';
import 'package:tdd_example/features/comments/data/models/comment_model.dart';

abstract interface class CommentsDatasource {
  Future<Either<dynamic, List<CommentModel>>> getComments({
    required Duration cacheDuration,
  });

  Future<void> clear();
}

@LazySingleton(as: CommentsDatasource)
class CommentsDatasourceImpl implements CommentsDatasource {
  final DioClient _dioClient;

  CommentsDatasourceImpl(this._dioClient);

  @override
  Future<Either<dynamic, List<CommentModel>>> getComments({
    required Duration cacheDuration,
  }) async {
    final client = _dioClient.client(cacheDuration: cacheDuration);
    const path = '/comments';
    try {
      final response = await client.get(path);
      final listData = response.data as List;
      final result = listData.map((e) => CommentModel.fromJson(e)).toList();
      return Right(result);
    } catch (e) {
      return Left(getError(e));
    }
  }

  @override
  Future<void> clear() async {
    await _dioClient.clearCache();
  }
}
