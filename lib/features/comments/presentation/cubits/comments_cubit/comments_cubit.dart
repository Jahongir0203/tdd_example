import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:tdd_example/core/helpers/app_toast.dart';
import 'package:tdd_example/core/helpers/enum_helpers.dart';
import 'package:tdd_example/features/comments/data/models/comment_model.dart';
import 'package:tdd_example/features/comments/domain/repository/comments_repository.dart';

part 'comments_state.dart';

part 'comments_cubit.freezed.dart';

@Injectable()
class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit(CommentsRepository commentsRepository)
    : _commentsRepository = commentsRepository,
      super(const CommentsState.initial());
  final CommentsRepository _commentsRepository;
  final _cacheDuration = Duration(hours: 1);
  final page = 1;

  Future<void> refresh() async {
    await _commentsRepository.clear();
    await getComments();
  }

  Future<void> getComments() async {
    emit(state.copyWith(status: .loading));
    final result = await _commentsRepository.getComments(
      cacheDuration: _cacheDuration,
    );
    
    result.fold(
      (l) => emit(state.copyWith(status: .fail, error: l)),
      (r) => emit(state.copyWith(status: .success, comments: r)),
    );
  }
}
