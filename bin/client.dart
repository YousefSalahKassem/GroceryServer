import 'package:dart_grpc_server/dart_grpc_server.dart';
import 'package:grpc/grpc.dart';
import 'dart:io';
import 'dart:math';

class Client {
  ClientChannel? channel;
  GroceriesServiceClient? stub;
  var response;
  bool executionInProgress = true;

  Future<void> main () async {
    channel = ClientChannel(
      'localhost',
      port: 50000,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    stub = GroceriesServiceClient(channel!, options: CallOptions(timeout: Duration(seconds: 30)));

    while (executionInProgress){
      try {
        print('---- Welcome to the dart store API ---');
        print('   ---- what do you want to do? ---');
        print('👉 1: View all products');
        print('👉 2: Add new product');
        print('👉 3: Edit product');
        print('👉 4: Get product');
        print('👉 5: Delete product \n');
        print('👉 6: View all categories');
        print('👉 7: Add new category');
        print('👉 8: Edit category');
        print('👉 9: Get category');
        print('👉 10: Delete category \n');
        print('👉 11: Get all products of given category');

        var option = int.parse(stdin.readLineSync()!);

        switch (option) {
          case 1:
            response = await stub!.getAllItems(Empty());
            print('👉 All products:');
            response.items.forEach((item) {
              print('👉 ${item.name}');
            });
            break;
          case 2:
            print('👉 Enter product name:');
            var name = stdin.readLineSync()!;
            var product = await _findItemByName(name);
            if (product.id != 0) {
              print('👉 Product already exists');
            } else {
              print('👉 Enter product category:');
              var categoryName = stdin.readLineSync()!;
              var category = await _findCategoryByName(categoryName);
              if(category.id==0){
                print('👉 Category does not exist');
              }
              var item = Item()
                ..name = name
                ..id = _randomId()
                ..categoryId = category.id;
              response = await stub!.createItem(item);
              print('👉 Product added');
            }
            break;
          case 3:
            print('👉 Enter product name:');
            var name = stdin.readLineSync()!;
            var product = await _findItemByName(name);
            if (product.id == 0) {
              print('👉 Product does not exist');
            } else {
              print('👉 Enter new product name:');
              var newName = stdin.readLineSync()!;
              var item = Item()
                ..name = newName
                ..id = product.id
                ..categoryId = product.categoryId;
              response = await stub!.editItem(item);
              print('👉 Product updated');
            }
            break;
          case 4:
            print('👉 Enter product name:');
            var name = stdin.readLineSync()!;
            var product = await _findItemByName(name);
            if (product.id == 0) {
              print('👉 Product does not exist');
            } else {
              print('👉 Product:');
              print('👉 ${product.name}');
            }
            break;
          case 5:
            print('👉 Enter product name:');
            var name = stdin.readLineSync()!;
            var product = await _findItemByName(name);
            if (product.id == 0) {
              print('👉 Product does not exist');
            } else {
              response = await stub!.deleteItem(product);
              print('👉 Product deleted');
            }
            break;
          case 6:
            response = await stub!.getAllCategories(Empty());
            print('👉  --- Store product categories ---');
            response.categories.forEach((category) {
              print('👉 ${category.name}  ${category.id}');
            });
            break;
          case 7:
            print('Enter category name: ');
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if (category.id != 0){
              print('Category already exists with id: ${category.id} and name: ${category.name}');
            }else{
              category=Category()
                ..id = Random(999).nextInt(9999)
                ..name = name;
              response = await stub!.createCategory(category);
              print('Category created: name ${category.name} and id ${category.id}');
            }
            break;
          case 8:
            print('Enter category name');
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if(category.id != 0){
              print('Enter new category name');
              name = stdin.readLineSync()!;
              response = await stub!.editCategory(Category(id: category.id, name: name));
              if(response.name == name){
                print('✅ category updated | name ${response.name} | id ${response.id}');

              }else{
                print('🔴 category update failed 🥲');
              }
            }else{
              print('🔴 category $name not found, try creating it!');
            }
            break;
          case 9:
            print('Enter category name: ');
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              print('Category found, id: ${category
                  .id} and name: ${category.name}');
            }else{
              print('Category not found');
            }
            break;
          case 10:
            print('Enter category name: ');
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              response = await stub!.deleteCategory(category);
              print('Category deleted: name ${category.name} and id ${category.id}');
            }else{
              print('Category not found');
            }
            break;
          case 11:
            print('Enter category name: ');
            var name = stdin.readLineSync()!;
            var category = await _findCategoryByName(name);
            if (category.id != 0) {
              response = await stub!.getItemsByCategory(category);
              print('👉 All products of category ${category.name}:');
              response.items.forEach((item) {
                print('👉 ${item.name}');
              });
            }else{
              print('Category not found');
            }
            break;
          default: print('invalid option');
        }
      } catch (e) {
        print(e);
      }

      print('Do you wish to exit the store? (y/n)');
      var result = stdin.readLineSync() ?? 'y';
      executionInProgress = result.toLowerCase() != 'y';
    }

    await channel!.shutdown();
  }


  Future<Category> _findCategoryByName(String name)async {
    var category =
    Category()
      ..name = name
    ;
    category = await stub!.getCategory(category);
    return category;
  }

  Future<Item> _findItemByName(String name) async {
      var item = Item()..name = name;
      item = await stub!.getItem(item);
      return item;
  }

  int _randomId() => Random(1000).nextInt(9999);
}

void main() {
  var client =Client();
  client.main();
}