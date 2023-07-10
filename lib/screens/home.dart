import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../components/post_list.dart';
import '../my_search_delegate.dart';
import '../search.dart';
import '../service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);
  List<dynamic> posts = [];

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchPosts(_pagingController, pageKey);
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
        title: const Text('Amici Domenicani'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              refreshPosts();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              myShowSearch(
                context: context,
                delegate: PostSearchDelegate(),
              );
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
            return Post(post: post);
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
