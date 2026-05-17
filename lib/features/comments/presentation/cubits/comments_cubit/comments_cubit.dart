import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:tdd_example/core/helpers/enum_helpers.dart';

part 'comments_state.dart';

part 'comments_cubit.freezed.dart';

@Injectable()
class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit() : super(const CommentsState.initial());
  final _cacheDuration = Duration(hours: 1);
  final page = 1;

  Future<void> getComments() async {
    emit(state.copyWith(status: .loading));
  }
}
