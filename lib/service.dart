import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

Future<void> fetchPosts(
    PagingController<int, dynamic> pagingController, int pageKey) async {
  final url = Uri.parse(
      'https://www.amicidomenicani.it/wp-json/wp/v2/posts?per_page=10&page=$pageKey');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> fetchedPosts = jsonDecode(response.body);
      final isLastPage = fetchedPosts.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(fetchedPosts);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(fetchedPosts, nextPageKey);
      }
    } else {
      throw Exception(response.body);
    }
  } catch (error) {
    pagingController.error = error;
  }
}

Future<void> fetchPostsByCategory(
    PagingController<int, dynamic> pagingController,
    int pageKey,
    int categoryId) async {
  final url = Uri.parse(
      'https://www.amicidomenicani.it/wp-json/wp/v2/posts?per_page=10&page=$pageKey&categories=$categoryId');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> fetchedPosts = jsonDecode(response.body);
      final isLastPage = fetchedPosts.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(fetchedPosts);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(fetchedPosts, nextPageKey);
      }
    } else {
      throw Exception(response.body);
    }
  } catch (error) {
    pagingController.error = error;
  }
}

Future<void> fetchCategories(PagingController<int, dynamic> pagingController,
    int pageKey, int parent) async {
  final url = Uri.parse(
      'https://www.amicidomenicani.it/wp-json/wp/v2/categories?per_page=10&page=$pageKey&orderby=id&parent=$parent');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> fetchedPosts = jsonDecode(response.body);
      final isLastPage = fetchedPosts.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(fetchedPosts);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(fetchedPosts, nextPageKey);
      }
    } else {
      throw Exception(response.body);
    }
  } catch (error) {
    pagingController.error = error;
  }
}

Future<List> fetchSubCategories(int parent) async {
  final url = Uri.parse(
      'https://www.amicidomenicani.it/wp-json/wp/v2/categories?orderby=id&parent=$parent');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> fetchedPosts = jsonDecode(response.body);
      return fetchedPosts;
    } else {
      throw Exception(response.body);
    }
  } catch (error) {
    return [];
  }
}

Future<void> searchPosts(PagingController<int, dynamic> pagingController,
    String keyword, int pageKey) async {
  final url = Uri.parse(
      'https://www.amicidomenicani.it/wp-json/wp/v2/posts?search=$keyword&per_page=10&page=$pageKey');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List<dynamic> searchResults = jsonDecode(response.body);
    final isLastPage = searchResults.length < 10;
    if (isLastPage) {
      pagingController.appendLastPage(searchResults);
    } else {
      final nextPageKey = pageKey + 1;
      pagingController.appendPage(searchResults, nextPageKey);
    }
  } else {
    pagingController.error = response.statusCode;
    return;
  }
}
