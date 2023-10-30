import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return I18n(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search....',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {},
            ),
          ),
          body: Container(),
        ),
      ),
    );
  }
}
