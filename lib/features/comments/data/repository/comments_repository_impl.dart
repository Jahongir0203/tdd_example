import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:tdd_example/features/comments/data/datasource/comments_datasource.dart';
import 'package:tdd_example/features/comments/data/models/comment_model.dart';
import 'package:tdd_example/features/comments/domain/repository/comments_repository.dart';

@LazySingleton(as: CommentsRepository)
class CommentsRepositoryImpl implements CommentsRepository {
  final CommentsDatasource _commentsDatasource;

  CommentsRepositoryImpl(this._commentsDatasource);

  @override
  Future<Either<dynamic, List<CommentModel>>> getComments({
    required Duration cacheDuration,
  }) async {
    return await _commentsDatasource.getComments(cacheDuration: cacheDuration);
  }

  @override
  Future<void> clear() async => await _commentsDatasource.clear();
}
