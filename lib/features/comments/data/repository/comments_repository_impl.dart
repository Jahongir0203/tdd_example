import 'package:injectable/injectable.dart';
import 'package:tdd_example/features/comments/domain/repository/comments_repository.dart';

@LazySingleton(as: CommentsRepository)
class CommentsRepositoryImpl implements CommentsRepository {}
