

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/my_storage_cubit.dart';

class DropdownMenu extends StatelessWidget {
  const DropdownMenu({super.key, required this.fileId, this.newFileName});
  final String fileId;
  final String? newFileName;

  @override
  Widget build(BuildContext context) {

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/fullScreen', arguments: fileId),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FilePreview(fileId: fileId),
            ),
          ),
        ),
        openWithLongPress: true,
        customItemsIndexes: const [4],
        customItemsHeight: 8,
        items: <DropdownMenuItem>[
          ...MenuItems.firstItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value as MenuItem, fileId, newFileName);
        },
        itemHeight: 50,
        itemPadding: const EdgeInsets.only(left: 16, right: 16),
        dropdownWidth: 200,
        dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.blue.shade800,
        ),
        dropdownElevation: 8,
        offset: const Offset(40, -4),
      ),
    );
  }
}

class FilePreview extends StatelessWidget {
  const FilePreview({super.key, required this.fileId});
  final String fileId;

  @override
  Widget build(BuildContext context) {
    final MyStorageCubit myStorageCubit = context.read<MyStorageCubit>();
    return FutureBuilder(
      future: myStorageCubit.getFilePreview(fileId), //works for both public file and private file, for private files you need to be logged in
      builder: (context, snapshot) {
        return snapshot.hasData && snapshot.data != null ? Image.memory(snapshot.data) : const CircularProgressIndicator();
      },
    );
  }
}

class Uint8List {
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [open, download, rename, remove];

  static const open = MenuItem(text: 'Открыть', icon: Icons.open_in_full_outlined);
  static const download = MenuItem(text: 'Скачать', icon: Icons.download_outlined);
  static const rename = MenuItem(text: 'Переименовать', icon: Icons.drive_file_rename_outline);
  static const remove = MenuItem(text: 'Удалить', icon: Icons.delete_forever_outlined);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: Colors.white,
          size: 22,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item, String fileId, String? newFileName) {
    final MyStorageCubit myStorageCubit = context.read<MyStorageCubit>();
    switch (item) {
      case MenuItems.open:
        Navigator.of(context).pushNamed('/fullScreen', arguments: fileId);
        break;
      case MenuItems.download:
        //Do something
        break;
      case MenuItems.rename:
        // if(newFileName != null) myStorageCubit.renameFile(fileId, newFileName);
        break;
      case MenuItems.remove:
        myStorageCubit.deleteFile(fileId);
        break;
    }
  }
}
