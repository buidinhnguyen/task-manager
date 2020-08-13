import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/category_model.dart';
import 'package:task_manager/stores/store_category.dart';

//TODO: This page should be used to update categories
class SelectCategoryPage extends StatelessWidget {
  CategoryStore categoryStore;
  final String todoId;
  String name;
  SelectCategoryPage(this.todoId);

  @override
  Widget build(BuildContext context) {
    categoryStore = Provider.of<CategoryStore>(context);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Select Category'),
            ),
            body: Material(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Observer(builder: (_) => _buildGridView()),
              ),
            )));
  }

  GridView _buildGridView() {
    List<Category> allcategories = <Category>[];

    if (categoryStore.categories != null &&
        categoryStore.categories.data != null) {
      categoryStore.categories.data.forEach((c) => {
            allcategories.add(c),
          });
    }

    return GridView.count(
      crossAxisCount: 4,
      children: List.generate(allcategories.length, (index) {
        return Center(
          child: GestureDetector(
            onTap: () => {},
            child: CircleAvatar(
              backgroundImage: NetworkImage(allcategories[index].imageUrl),
              maxRadius: 40,
            ),
          ),
        );
      }),
    );
  }
}
