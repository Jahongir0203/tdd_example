import 'package:injectable/injectable.dart';

abstract interface class CommentsDatasource {}

@LazySingleton(as: CommentsDatasource)
class CommentsDatasourceImpl implements CommentsDatasource {

}
