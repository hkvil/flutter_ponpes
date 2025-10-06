import '../constants/detail_lists.dart';

/// Returns the correct detail menu items for a given title and item.
List<String> getDetailMenuItems(String title) {
  print(title);
  if (title == 'Organ Penyelenggara Pendidikan Formal') {
    return menuItemsJenis2;
  }
  return menuItemsJenis1;
}
