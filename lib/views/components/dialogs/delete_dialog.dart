import 'package:flutter/material.dart';
import 'package:insta_closachin/views/components/dialogs/alert_dialog_model.dart';

import '../constants/strings.dart';

@immutable
class DeleteDialog extends AlertDialogModel<bool> {
  const DeleteDialog({
    required String titleOfObjectToDelete,
  }) : super(
            title: '${Strings.delete} $titleOfObjectToDelete?',
            message:
                '${Strings.areYouSureYouWantToDeleteThis} $titleOfObjectToDelete?',
            buttons: const {
              Strings.cancel: false,
              Strings.delete: true,
            });
}
