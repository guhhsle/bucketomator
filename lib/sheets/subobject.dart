import 'package:flutter/material.dart';
import '../services/subobject.dart';
import '../template/functions.dart';
import '../template/tile_card.dart';
import '../template/data.dart';
import '../template/tile.dart';

class SubobjectSheet extends StatelessWidget {
  final Widget child;
  final Subobject subobject;

  const SubobjectSheet({
    super.key,
    required this.child,
    required this.subobject,
  });

  @override
  Widget build(BuildContext c) {
    double bottom = MediaQuery.of(c).viewInsets.vertical;
    if (bottom > 16) bottom -= 16;
    return Semantics(
      label: 'Bottom sheet',
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.2,
        builder: (c, controller) => ListenableBuilder(
          listenable: subobject,
          builder: (c, snapshot) => Card(
            elevation: 6,
            margin: const EdgeInsets.all(8),
            color: Theme.of(c).colorScheme.surface.withValues(alpha: 0.8),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TileCard(
                                Tile(
                                  subobject.name,
                                  Icons.edit_rounded,
                                  '',
                                  () => getInput(subobject.name, 'Name').then((
                                    s,
                                  ) {
                                    //TODO rename
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            physics: scrollPhysics,
                            padding: EdgeInsets.only(
                              bottom: 64,
                              left: 4,
                              right: 4,
                            ),
                            child: child,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
