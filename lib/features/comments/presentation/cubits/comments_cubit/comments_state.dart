part of 'comments_cubit.dart';

@freezed
abstract class CommentsState with _$CommentsState {
  const factory CommentsState.initial({
    @Default(RequestStatus.initial) RequestStatus status,
    @Default([]) List<CommentModel> comments,
    @Default('') String error,
  }) = _Initial;
}
