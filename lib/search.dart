import 'package:amici_domenicani/service.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'components/post_list.dart';
import 'my_search_delegate.dart';

class PostSearchDelegate extends MySearchDelegate<String> {
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  String _currentQuery = '';

  PostSearchDelegate() {
    _pagingController.addPageRequestListener((pageKey) {
      searchPosts(_pagingController, query, pageKey);
    });
  }

  @override
  String get searchFieldLabel => 'Cerca...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _pagingController.itemList?.clear();
          focus(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        _pagingController.dispose();
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (_currentQuery != query) {
      _currentQuery = query;
      _pagingController.refresh();
    }
    return PagedListView<int, dynamic>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<dynamic>(
        itemBuilder: (context, post, index) {
          return Post(post: post);
        },
        noItemsFoundIndicatorBuilder: (context) {
          return Center(
            child: Text(
              'Nessun risultato',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink();
  }
}
