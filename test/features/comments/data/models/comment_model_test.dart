import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_example/features/comments/data/models/comment_model.dart';

//Unit Test for CommentModel
void main() {
  group('CommentModel testing', () {
    const tJson = {
      'postId': 1,
      'id': 42,
      'name': 'John Doe',
      'email': 'john@example.com',
      'body': 'Hello world!',
    };

    const tModel = CommentModel(
      postId: 1,
      id: 42,
      name: 'John Doe',
      email: 'john@example.com',
      body: 'Hello world!',
    );

    test('fromJson -Jsondan to\'g\'ri model yasaydi!', () {
      final result = CommentModel.fromJson(tJson);
      expect(result, equals(tModel));
    });

    test('DEFAULT qiymatlar - bo\'sh json bilan ishlaydi!', () {
      final result = CommentModel.fromJson({});
      expect(result.postId, equals(0));
      expect(result.id, equals(0));
      expect(result.email, equals(''));
      expect(result.name, equals(''));
      expect(result.body, equals(''));
    });
  });
}
