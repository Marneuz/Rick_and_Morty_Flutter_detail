import 'dart:async';

import 'package:rick_and_morty/models/characters_network_response.dart';
import 'package:rick_and_morty/models/resource_state.dart';
import 'package:rick_and_morty/repositories/characters_repository.dart';

typedef CharacterListState = ResourceState<CharactersNetworkResponse>;
typedef CharacterDetailState = ResourceState<CharacterNetworkResponse>;

class CharactersViewModel {
  final CharactersRepository _repository = CharactersRepository();

  StreamController<CharacterListState> getCharactersState = StreamController();
  StreamController<CharacterDetailState> getCharacterDetailState =
      StreamController();

  dispose() {
    getCharactersState.close();
    getCharacterDetailState.close();
  }

  fetchCharacters(int page) {
    getCharactersState.add(ResourceState.loading());

    _repository
        .getCharacters(page)
        .then((value) => getCharactersState.add(ResourceState.success(value)))
        .catchError((e) => getCharactersState.add(ResourceState.error(e)));
  }

  fetchCharacterDetail(int id) {
    getCharacterDetailState.add(ResourceState.loading());

    _repository
        .getCharacter(id)
        .then((value) =>
            getCharacterDetailState.add(ResourceState.success(value)))
        .catchError((e) => getCharacterDetailState.add(ResourceState.error(e)));
  }
}
