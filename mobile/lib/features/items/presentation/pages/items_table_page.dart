import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse_manager/features/items/bloc/table/items_table_bloc.dart';
import 'package:warehouse_manager/features/items/bloc/table/items_table_event.dart';
import 'package:warehouse_manager/features/items/bloc/table/items_table_state.dart';
import 'package:warehouse_manager/features/items/presentation/pages/item_form_page.dart';
import '../../data/repositories/items_repository.dart';

class ItemsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articoli'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ItemFormPage()),
              );
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) =>
            ItemsTableBloc(itemRepository: context.read<ItemsRepository>())
              ..add(LoadItems()),
        child: _ItemListView(),
      ),
    );
  }
}

class _ItemListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsTableBloc, ItemsTableState>(
      builder: (context, state) {
        if (state is ItemsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ItemsLoaded) {
          return Column(
            children: [
              _buildSearchBar(context),
              _buildTable(context, state),
            ],
          );
        } else {
          return Container();
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
        decoration: const InputDecoration(
          labelText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onSubmitted: (query) {
          context.read<ItemsTableBloc>().add(SearchItems(query: query));
        },
      ),
    );
  }
}

Widget _buildTable(BuildContext context, ItemsLoaded state)
{
  return Expanded(
    child: DataTable2(
      showCheckboxColumn: false,
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 600,
      columns: [
        const DataColumn2(
          label: Text('ID'),
          size: ColumnSize.S,
        ),
        const DataColumn(
          label: Text('Name'),
        ),
      ],
      rows: List<DataRow>.generate(
        state.items.length,
            (index) => DataRow(
            onSelectChanged: (_) {
              Navigator.pushNamed(
                  context, "/item");
            },
            cells: [
              DataCell(Text(state.items[index].id.toString())),
              DataCell(Text(state.items[index].name)),
            ]),
      ),
    ),
  );
}
