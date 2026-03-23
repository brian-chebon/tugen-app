import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../providers/phrasebook_providers.dart';
import '../widgets/category_card.dart';


class PhrasebookScreen extends ConsumerWidget {
  const PhrasebookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final categories = ref.watch(categoriesProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(phraseSearchProvider(searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.phrasebook),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {
              // Show bookmarked phrases bottom sheet
              _showBookmarks(context, ref);
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: PhraseSearchBar(
                onChanged: (q) =>
                    ref.read(searchQueryProvider.notifier).update(q),
              ),
            ),
          ),

          // Show search results or categories
          if (searchQuery.isNotEmpty)
            searchResults.when(
              data: (phrases) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final phrase = phrases[index];
                    return ListTile(
                      title: Text(phrase.tugen),
                      subtitle: Text(phrase.english),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.go('/phrasebook/phrase/${phrase.id}'),
                    );
                  },
                  childCount: phrases.length,
                ),
              ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Error: $e')),
              ),
            )
          else
            categories.when(
              data: (cats) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final cat = cats[index];
                      return CategoryCard(
                        category: cat,
                        onTap: () =>
                            context.go('/phrasebook/category/${cat.id}'),
                      );
                    },
                    childCount: cats.length,
                  ),
                ),
              ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Error loading categories: $e')),
              ),
            ),
        ],
      ),
    );
  }

  void _showBookmarks(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.read(bookmarkedPhrasesProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context).bookmarkedPhrases,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: bookmarks.when(
                data: (phrases) => phrases.isEmpty
                    ? Center(child: Text(AppLocalizations.of(context).noBookmarks))
                    : ListView.builder(
                        controller: controller,
                        itemCount: phrases.length,
                        itemBuilder: (ctx, i) {
                          final p = phrases[i];
                          return ListTile(
                            title: Text(p.tugen),
                            subtitle: Text(p.english),
                            onTap: () {
                              Navigator.pop(ctx);
                              context.go('/phrasebook/phrase/${p.id}');
                            },
                          );
                        },
                      ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
