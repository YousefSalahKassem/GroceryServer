import 'package:dart_grpc_server/dart_grpc_server.dart';

abstract class IItemsServices{
  factory IItemsServices() => ItemsServices();

  Item? getItemById(int id);
  Item? getItemByName(String name);
  Item? createItem(Item item);
  Item? editItem(Item item);
  Empty? deleteItem(int id);

  List<Item>? getItems();
  List<Item>? getItemsByCategory(int categoryId);
}
final itemServices = IItemsServices();