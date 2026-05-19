import 'package:dartz/dartz.dart';
import 'package:tdd_example/features/comments/data/models/comment_model.dart';

abstract interface class CommentsRepository {
  Future<Either<dynamic, List<CommentModel>>> getComments({
    required Duration cacheDuration,
  });

  Future<void> clear();
}
