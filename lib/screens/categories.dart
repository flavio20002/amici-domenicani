import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../components/category.dart';
import '../service.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchCategories(_pagingController, pageKey, 4);
    });
    super.initState();
  }

  Future<void> refreshPosts() async {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorie'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              refreshPosts();
            },
          ),
        ],
      ),
      body: PagedListView<int, dynamic>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<dynamic>(
          firstPageErrorIndicatorBuilder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: InkWell(
                child: Text(
                  "Si è verificato un errore di rete. Tocca per riprovare",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                onTap: () {
                  _pagingController.retryLastFailedRequest();
                },
              ),
            ),
          ),
          newPageErrorIndicatorBuilder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: InkWell(
                child: Text(
                  "Si è verificato un errore di rete. Tocca per riprovare",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  _pagingController.retryLastFailedRequest();
                },
              ),
            ),
          ),
          itemBuilder: (context, post, index) {
            return MyCategory(post: post, getChildren: fetchSubCategories);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
