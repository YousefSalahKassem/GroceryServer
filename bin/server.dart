import 'package:dart_grpc_server/dart_grpc_server.dart';
import 'package:grpc/grpc.dart';

class GroceriesService extends GroceriesServiceBase {

  @override
  Future<Category> createCategory(ServiceCall call, Category request) async => categoriesServices.createCategory(request)!;

  @override
  Future<Item> createItem(ServiceCall call, Item request) async => itemServices.createItem(request)!;

  @override
  Future<Empty> deleteCategory(ServiceCall call, Category request) async => categoriesServices.deleteCategory(request.id)!;

  @override
  Future<Empty> deleteItem(ServiceCall call, Item request) async => itemServices.deleteItem(request.id)!;

  @override
  Future<Category> editCategory(ServiceCall call, Category request) async => categoriesServices.editCategory(request)!;

  @override
  Future<Item> editItem(ServiceCall call, Item request) async => itemServices.editItem(request)!;

  @override
  Future<Categories> getAllCategories(ServiceCall call, Empty request) async => Categories()..categories.addAll(categoriesServices.getCategories()!);

  @override
  Future<Items> getAllItems(ServiceCall call, Empty request) async => Items()..items.addAll(itemServices.getItems()!);

  @override
  Future<Category> getCategory(ServiceCall call, Category request) async => categoriesServices.getCategoryByName(request.name)!;

  @override
  Future<Item> getItem(ServiceCall call, Item request) async => itemServices.getItemById(request.id)!;

  @override
  Future<AllItemsOfCategory> getItemsByCategory(ServiceCall call, Category request) async => AllItemsOfCategory()..items.addAll(itemServices.getItemsByCategory(request.id)!);
}

Future<void> main() async {
  final server = Server(
    [GroceriesService()],
    const <Interceptor>[],
    CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()])
  );
  await server.serve(port: 50000);
  print('server listening on port ${server.port}');
}
