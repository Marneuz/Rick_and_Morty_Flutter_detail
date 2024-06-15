import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/characters_network_response.dart';
import 'package:rick_and_morty/models/resource_state.dart';
import 'package:rick_and_morty/viewmodels/characters_view_model.dart';
import 'package:rick_and_morty/widgets/character_list_row.dart';
import 'package:rick_and_morty/widgets/error/error_view.dart';
import 'package:rick_and_morty/widgets/loading/loading_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CharactersViewModel _viewModel = CharactersViewModel();
  final ScrollController _scrollController = ScrollController();
  final List<CharacterNetworkResponse> _characters = List.empty(growable: true);

  bool _hasMoreItems = true;
  int _nextPage = 1;

  @override
  void initState() {
    super.initState();

    _viewModel.getCharactersState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          _addCharacters(state.data!);
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.error.toString(), () {
            _viewModel.fetchCharacters(_nextPage);
          });
          break;
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _hasMoreItems) {
        _viewModel.fetchCharacters(_nextPage);
      }
    });

    _viewModel.fetchCharacters(_nextPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick & Morty"),
      ),
      body: SafeArea(
        child: _getContentView(),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 1050),
          curve: Curves.decelerate,
        ),
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Widget _getContentView() {
    return RefreshIndicator(
      onRefresh: () async {
        _nextPage = 1;
        _viewModel.fetchCharacters(_nextPage);
      },
      child: Scrollbar(
        controller: _scrollController,
        child: ListView.separated(
          controller: _scrollController,
          itemCount: _characters.length,
          itemBuilder: (context, index) {
            final item = _characters[index];
            return CharacterListRow(character: item);
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        ),
      ),
    );
  }

  _addCharacters(CharactersNetworkResponse response) {
    if (_nextPage == 1) {
      // First page, remove previous data
      _characters.clear();
    }

    _characters.addAll(response.results);
    _hasMoreItems = response.info.count > _characters.length;
    _nextPage += 1;

    setState(() {});
  }
}
