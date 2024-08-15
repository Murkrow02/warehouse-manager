import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/item_event.dart';
import '../../bloc/item_list_bloc.dart';
import '../../bloc/item_state.dart';
import '../../data/repositories/items_mock_repository.dart';
import '../../data/repositories/items_repository.dart';

class ItemsListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ItemCreateScreen()),
              // );
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => ItemListBloc(itemRepository: context.read<ItemsRepository>())
          ..add(LoadItems()),
        child: _ItemListView(),
      ),
    );
  }
}

class _ItemListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemListBloc, ItemState>(
      builder: (context, state) {
        if (state is ItemLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ItemLoaded) {
          return Column(
            children: [
              _buildSearchBar(context),
              Expanded(
                child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  columns: [
                    DataColumn2(
                      label: Text('ID'),
                      size: ColumnSize.S,
                    ),
                    DataColumn(
                      label: Text('Name'),
                    ),
                    DataColumn(
                      label: Text('Price'),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    state.items.length,
                    (index) => DataRow(cells: [
                      DataCell(Text(state.items[index].id.toString())),
                      DataCell(Text(state.items[index].name)),
                      DataCell(Text(state.items[index].price.toString())),
                    ]),
                  ),
                ),
              ),
            ],
          );
        } else if (state is ItemError) {
          return Center(child: Text('Failed to load items: ${state.message}'));
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final _searchController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onSubmitted: (query) {
          context.read<ItemListBloc>().add(SearchItems(query: query));
        },
      ),
    );
  }
}
