import 'package:flutter/material.dart';
import 'package:neon_framework/src/utils/adaptive.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

@visibleForTesting
class SettingsList extends StatelessWidget {
  const SettingsList({
    required this.categories,
    this.initialCategory,
    super.key,
  });

  final List<Widget> categories;
  final String? initialCategory;

  int? _getIndex(final String? initialCategory) {
    if (initialCategory == null) {
      return null;
    }

    final key = Key(initialCategory);
    final index = categories.indexWhere((final category) => category.key == key);

    return index != -1 ? index : null;
  }

  @override
  Widget build(final BuildContext context) {
    final hasPadding = !isCupertino(context);

    return ScrollablePositionedList.builder(
      padding: hasPadding ? const EdgeInsets.symmetric(horizontal: 20) : null,
      itemCount: categories.length,
      initialScrollIndex: _getIndex(initialCategory) ?? 0,
      itemBuilder: (final context, final index) => categories[index],
    );
  }
}
