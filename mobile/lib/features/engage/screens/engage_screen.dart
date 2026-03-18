import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/portal_header.dart';
import '../../../shared/widgets/section_header.dart';

class EngagePost {
  final String author;
  final String message;
  final DateTime createdAt;

  EngagePost({
    required this.author,
    required this.message,
    required this.createdAt,
  });
}

class EngageState {
  final List<EngagePost> posts;

  const EngageState({this.posts = const []});
}

class EngageNotifier extends StateNotifier<EngageState> {
  EngageNotifier()
      : super(
          EngageState(
            posts: [
              EngagePost(
                author: 'HRMS',
                message: 'Welcome to Engage — company updates will show here.',
                createdAt: DateTime.now().subtract(const Duration(hours: 3)),
              ),
            ],
          ),
        );

  void addPost({required String author, required String message}) {
    final next = [
      EngagePost(author: author, message: message, createdAt: DateTime.now()),
      ...state.posts,
    ];
    state = EngageState(posts: next);
  }
}

final engageProvider = StateNotifierProvider<EngageNotifier, EngageState>((ref) {
  return EngageNotifier();
});

class EngageScreen extends ConsumerWidget {
  final VoidCallback? onOpenProfile;

  const EngageScreen({
    super.key,
    this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(engageProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          PortalHeader(onProfileTap: onOpenProfile),
          const SizedBox(height: 16),
          Text(
            'Engage',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Posts, celebrations, and announcements.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          SectionHeader(
            title: 'Celebrations',
            actionLabel: 'Auto',
            onAction: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Birthday/anniversary automation coming soon.'),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              leading: Icon(Icons.cake_rounded),
              title: Text('Happy Birthday'),
              subtitle: Text('We’ll automatically wish teammates here.'),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.emoji_events_rounded),
              title: Text('Work Anniversary'),
              subtitle: Text('Celebrations will appear automatically.'),
            ),
          ),

          const SizedBox(height: 20),

          SectionHeader(
            title: 'Company feed',
            actionLabel: 'Post',
            onAction: () => _compose(context, ref),
          ),
          const SizedBox(height: 10),

          Card(
            child: Column(
              children: [
                for (int i = 0; i < state.posts.length; i++) ...[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        state.posts[i].author.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    title: Text(
                      state.posts[i].author,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(state.posts[i].message),
                    trailing: const Icon(Icons.more_vert_rounded),
                  ),
                  if (i != state.posts.length - 1)
                    Divider(height: 1, color: colorScheme.outlineVariant),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _compose(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New post',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  hintText: 'Share an update…',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final message = controller.text.trim();
                    if (message.isNotEmpty) {
                      ref
                          .read(engageProvider.notifier)
                          .addPost(author: 'You', message: message);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Post'),
                ),
              ),
            ],
          ),
        );
      },
    );

    controller.dispose();
  }
}
