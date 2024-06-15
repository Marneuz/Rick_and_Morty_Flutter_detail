import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty/models/characters_network_response.dart';
import 'package:rick_and_morty/models/resource_state.dart';
import 'package:rick_and_morty/viewmodels/characters_view_model.dart';
import 'package:rick_and_morty/widgets/error/error_view.dart';
import 'package:rick_and_morty/widgets/loading/loading_view.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.id});

  final int id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final CharactersViewModel _viewModel = CharactersViewModel();

  CharacterNetworkResponse? _character;

  @override
  void initState() {
    super.initState();

    _viewModel.getCharacterDetailState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _character = state.data;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.error.toString(), () {
            _viewModel.fetchCharacterDetail(widget.id);
          });
          break;
      }
    });

    _viewModel.fetchCharacterDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_character?.name ?? ''),
      ),
      body: _getContentView(),
    );
  }

  Widget _getContentView() {
    if (_character == null) return Container();

    return SingleChildScrollView(
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: _character!.image,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text("Gender: ${_character!.gender}"),
          const SizedBox(height: 16),
          Text("Species: ${_character!.species}"),
          const SizedBox(height: 16),
          Text("Location: ${_character!.location.name}"),
        ],
      ),
    );
  }
}
