import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class CAlert {
  static void success(BuildContext context, {String? content, void Function()? onConfirm}) => QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Successful',
        text: content,
        onConfirmBtnTap: onConfirm,
      );
  static void error(BuildContext context, {String? content, void Function()? onConfirm}) => QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Something went wrong',
        text: content,
        onConfirmBtnTap: onConfirm,
      );

  static void warn(BuildContext context, {String? content, void Function()? onConfirm}) => QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Warning',
        text: content,
        onConfirmBtnTap: onConfirm,
      );

  static void info(BuildContext context, {String? content, void Function()? onConfirm}) => QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: 'Information',
        text: content,
        onConfirmBtnTap: onConfirm,
      );

  static void confirm(BuildContext context, {String? content, void Function()? onConfirm, void Function()? onCancel}) =>
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Hold up',
        text: content,
        onConfirmBtnTap: onConfirm,
        onCancelBtnTap: onCancel,
      );
}
