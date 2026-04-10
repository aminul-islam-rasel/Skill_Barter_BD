import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample chat data
    final chats = [
      {
        'name': 'Rahul Ahmed',
        'lastMessage': 'Sure, see you tomorrow!',
        'time': '2m ago',
        'unread': 2,
        'avatar': 'R',
      },
      {
        'name': 'Fatima Khan',
        'lastMessage': 'Thanks for the lesson',
        'time': '1h ago',
        'unread': 0,
        'avatar': 'F',
      },
      {
        'name': 'Karim Hassan',
        'lastMessage': 'Can we reschedule?',
        'time': '3h ago',
        'unread': 1,
        'avatar': 'K',
      },
      {
        'name': 'Nusrat Jahan',
        'lastMessage': 'Great session!',
        'time': 'Yesterday',
        'unread': 0,
        'avatar': 'N',
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.cardShadowSmall,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.go('/chat/${chat['name']}'),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppTheme.primaryLight.withOpacity(
                              0.2,
                            ),
                            child: Text(
                              chat['avatar'] as String,
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if ((chat['unread'] as int) > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: const BoxDecoration(
                                  color: AppTheme.accentColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${chat['unread']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  chat['name'] as String,
                                  style: TextStyle(
                                    fontWeight: (chat['unread'] as int) > 0
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  chat['time'] as String,
                                  style: TextStyle(
                                    color: (chat['unread'] as int) > 0
                                        ? AppTheme.primaryColor
                                        : AppTheme.textHint,
                                    fontSize: 12,
                                    fontWeight: (chat['unread'] as int) > 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              chat['lastMessage'] as String,
                              style: TextStyle(
                                color: (chat['unread'] as int) > 0
                                    ? AppTheme.textPrimary
                                    : AppTheme.textSecondary,
                                fontSize: 13,
                                fontWeight: (chat['unread'] as int) > 0
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/explore');
              break;
            case 2:
              context.go('/sessions');
              break;
            case 3:
              context.go('/chats');
              break;
            case 4:
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
