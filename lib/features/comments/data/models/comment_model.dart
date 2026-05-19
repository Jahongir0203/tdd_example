import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';

part 'comment_model.g.dart';

@freezed
abstract class CommentModel with _$CommentModel {
  const factory CommentModel({
    @Default(0) @JsonKey(name: 'postId') int postId,
    @Default(0) int id,
    @Default('') String name,
    @Default('') String email,
    @Default('') String body,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}
