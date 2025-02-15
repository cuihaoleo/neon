import 'package:flutter/material.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/widgets.dart';
import 'package:neon_notes/l10n/localizations.dart';
import 'package:neon_notes/src/blocs/notes.dart';
import 'package:neon_notes/src/widgets/category_select.dart';
import 'package:nextcloud/notes.dart' as notes;

class NotesSelectCategoryDialog extends StatefulWidget {
  const NotesSelectCategoryDialog({
    required this.bloc,
    this.initialCategory,
    super.key,
  });

  final NotesBloc bloc;
  final String? initialCategory;

  @override
  State<NotesSelectCategoryDialog> createState() => _NotesSelectCategoryDialogState();
}

class _NotesSelectCategoryDialogState extends State<NotesSelectCategoryDialog> {
  final formKey = GlobalKey<FormState>();

  String? selectedCategory;

  void submit() {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).pop(selectedCategory);
    }
  }

  @override
  Widget build(final BuildContext context) => ResultBuilder<List<notes.Note>>.behaviorSubject(
        subject: widget.bloc.notesList,
        builder: (final context, final notes) => NeonDialog(
          title: Text(NotesLocalizations.of(context).category),
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: NeonError(
                      notes.error,
                      onRetry: widget.bloc.refresh,
                    ),
                  ),
                  Center(
                    child: NeonLinearProgressIndicator(
                      visible: notes.isLoading,
                    ),
                  ),
                  if (notes.hasData) ...[
                    NotesCategorySelect(
                      categories: notes.requireData.map((final note) => note.category).toSet().toList(),
                      initialValue: widget.initialCategory,
                      onChanged: (final category) {
                        selectedCategory = category;
                      },
                      onSubmitted: submit,
                    ),
                  ],
                  ElevatedButton(
                    onPressed: submit,
                    child: Text(NotesLocalizations.of(context).noteSetCategory),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
