import 'package:flutter/material.dart';

import '../../constants/const_space.dart';
import '../../constants/const_typography.dart';

class DialogSettings extends StatelessWidget {
  final void Function() onTapImportFile;

  const DialogSettings({super.key, required this.onTapImportFile});

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
            _settingItem(Icons.delete, 'Delete zone data', () {}),
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
