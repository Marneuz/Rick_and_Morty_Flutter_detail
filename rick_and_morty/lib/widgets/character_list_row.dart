import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty/models/characters_network_response.dart';
import 'package:rick_and_morty/navigation/navigation_routes.dart';

class CharacterListRow extends StatelessWidget {
  const CharacterListRow({super.key, required this.character});

  final CharacterNetworkResponse character;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go(NavigationRoutes.DETAIL, extra: character.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: character.image,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                character.name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
