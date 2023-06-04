import 'package:flutter/material.dart';
import 'package:google_map/widgets/custom_alert.dart';

import '../../constants/const_space.dart';
import '../../constants/const_typography.dart';

class DialogSettings extends StatelessWidget {
  final void Function() onTapImportFile;
  final void Function() onTapDeleteFile;

  const DialogSettings({super.key, required this.onTapImportFile, required this.onTapDeleteFile});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.secondary),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Settings', style: AppText.title),
          const SizedBox(height: AppSpace.primary),
          Column(children: [
            _settingItem(Icons.download, 'Import file KML', onTapImportFile),
            _settingItem(
              Icons.delete,
              'Delete zone data',
              () => CAlert.confirm(context, content: 'Are you sure want to delete?', onConfirm: onTapDeleteFile),
            ),
          ]),
        ]),
      ),
    );
  }

  ListTile _settingItem(IconData icon, String title, void Function() onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Text(title),
    );
  }
}
