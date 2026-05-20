// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:tdd_example/features/comments/presentation/pages/comments_page/comments_page.dart'
    as _i1;

/// generated route for
/// [_i1.CommentsPage]
class CommentsRoute extends _i2.PageRouteInfo<void> {
  const CommentsRoute({List<_i2.PageRouteInfo>? children})
    : super(CommentsRoute.name, initialChildren: children);

  static const String name = 'CommentsRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      return const _i1.CommentsPage();
    },
  );
}
