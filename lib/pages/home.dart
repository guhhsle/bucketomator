import 'package:flutter/material.dart';
import '../../template/animated_text.dart';
import '../../template/functions.dart';
import '../../template/settings.dart';
import '../../widgets/frame.dart';
import '../services/storage.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Storage(),
      builder: (context, child) {
        return Frame(
          automaticallyImplyLeading: false,
          title: Builder(
            builder: (context) => AnimatedText(
              text: t('S3'),
              speed: const Duration(milliseconds: 48),
              style: Theme.of(context).appBarTheme.titleTextStyle!,
              key: ValueKey(t('S3')),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () {
                Storage().init();
              },
            ),
            IconButton(
              tooltip: t('Settings'),
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => goToPage(const PageSettings()),
            ),
          ],
          child: ListView.builder(
            itemCount: Storage().sbuckets.length,
            itemBuilder: (context, i) => Storage().sbuckets[i].toWidget,
          ),
        );
      },
    );
  }
}
