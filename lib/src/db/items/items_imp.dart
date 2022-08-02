import 'package:dart_grpc_server/dart_grpc_server.dart';

class ItemsServices implements IItemsServices {
  @override
  Item? createItem(Item item) {
    items.add({'id': item.id, 'name': item.name, 'categoryId': item.categoryId});
    return item;
  }

  @override
  Empty? deleteItem(int id) {
    items.removeWhere((item) => item['id'] == id);
    return Empty();
  }

  @override
  Item? editItem(Item item) {
    try {
      var itemIndex = items.indexWhere((element) =>
      element['id'] == item.id);
      items[itemIndex]['name'] = item.name;
      items[itemIndex]['categoryId'] = item.categoryId;
    } catch (e) {
      print(e);
    }
    return item;
  }

  @override
  Item? getItemById(int id) {
    var item = Item();
    var result = items.where((item) => item['id'] == id).toList();
    if (result.isNotEmpty) {
      item = helper.getItemFromMap(result.first);
    }
    return item;
  }

  @override
  Item? getItemByName(String name) {
    var item = Item();
    var result = items.where((item) => item['name'] == name).toList();
    if (result.isNotEmpty) {
      item = helper.getItemFromMap(result.first);
    }
    return item;
  }

  @override
  List<Item> getItems() {
    return items.map((item) => helper.getItemFromMap(item)).toList();
  }

  @override
  List<Item> getItemsByCategory(int categoryId) {
    return items.where((item) => item['categoryId'] == categoryId)
        .map((item) => helper.getItemFromMap(item)).toList();
  }

}