// lib/screens/messages_screen.dart
import 'package:flutter/material.dart';
import 'package:csxi_app/services/data_service.dart';
import 'package:csxi_app/widgets/app_bar_widget.dart';
import 'package:csxi_app/widgets/side_menu.dart';
import 'package:csxi_app/config/routes.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late String _currentRoute;
  int _selectedIndex = 0;
  late TextEditingController _searchController;
  List<dynamic> _filteredMessages = [];
  dynamic _selectedContact;

  @override
  void initState() {
    super.initState();
    _currentRoute = AppRoutes.messages;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _searchController = TextEditingController();
    _filteredMessages = DataService.getMessages();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterMessages(String query) {
    final messages = DataService.getMessages();
    setState(() {
      if (query.isEmpty) {
        _filteredMessages = messages;
      } else {
        _filteredMessages =
            messages
                .where(
                  (message) =>
                      message.senderName.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      message.lastMessage.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = DataService.getUser();
    final menuItems = DataService.getMenuItems();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Messages',
        user: user,
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: SideMenu(
        menuItems: menuItems,
        currentRoute: _currentRoute,
        onRouteChanged: (route) {
          setState(() {
            _currentRoute = route;
          });
        },
        user: user,
      ),
      body: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
            ),
          ),
          child: Row(
            children: [
              // Chat List
              Expanded(
                flex: MediaQuery.of(context).size.width > 800 ? 1 : 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border(
                      right: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterMessages,
                          decoration: InputDecoration(
                            hintText: 'Search messages...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                      _buildTabs(),
                      Expanded(
                        child:
                            _filteredMessages.isEmpty
                                ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No messages found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : ListView.separated(
                                  itemCount: _filteredMessages.length,
                                  separatorBuilder:
                                      (context, index) =>
                                          const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final message = _filteredMessages[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          message.senderAvatar,
                                        ),
                                      ),
                                      title: Text(
                                        message.senderName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        message.lastMessage,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            message.time,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          if (message.unread > 0)
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                message.unread.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      selected: _selectedContact == message,
                                      selectedTileColor: Colors.grey[100],
                                      onTap: () {
                                        setState(() {
                                          _selectedContact = message;
                                        });
                                        if (MediaQuery.of(context).size.width <=
                                            800) {
                                          // Show chat detail in full screen on small devices
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      _buildChatDetailScreen(
                                                        message,
                                                      ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
              ),
              // Chat Detail (visible only on larger screens)
              if (MediaQuery.of(context).size.width > 800)
                Expanded(
                  flex: 2,
                  child:
                      _selectedContact == null
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat,
                                  size: 100,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Select a conversation to start chatting',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                          : _buildChatDetail(_selectedContact),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewConversation,
        tooltip: 'New Message',
        child: const Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                  _filterMessages(_searchController.text);
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chats',
                    style: TextStyle(
                      fontWeight:
                          _selectedIndex == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                      color:
                          _selectedIndex == 0
                              ? Theme.of(context).primaryColor
                              : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (_selectedIndex == 0)
                    Container(
                      height: 3,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                  // Filter only unread messages
                  _filteredMessages =
                      DataService.getMessages()
                          .where((m) => m.unread > 0)
                          .toList();
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Unread',
                    style: TextStyle(
                      fontWeight:
                          _selectedIndex == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                      color:
                          _selectedIndex == 1
                              ? Theme.of(context).primaryColor
                              : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (_selectedIndex == 1)
                    Container(
                      height: 3,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                  // Filter only important messages
                  _filteredMessages =
                      DataService.getMessages()
                          .where((m) => m.isImportant)
                          .toList();
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Important',
                    style: TextStyle(
                      fontWeight:
                          _selectedIndex == 2
                              ? FontWeight.bold
                              : FontWeight.normal,
                      color:
                          _selectedIndex == 2
                              ? Theme.of(context).primaryColor
                              : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (_selectedIndex == 2)
                    Container(
                      height: 3,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatDetail(dynamic contact) {
    final messages = contact.conversation;
    final user = DataService.getUser();

    return Column(
      children: [
        // Chat header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(contact.senderAvatar),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.senderName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Active now',
                      style: TextStyle(fontSize: 12, color: Colors.green[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.call),
                onPressed: () {
                  // Call action
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // More options
                },
              ),
            ],
          ),
        ),
        // Chat messages
        Expanded(
          child: Container(
            color: Colors.grey[100],
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                final isMe = message.sender == 'me';

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          isMe ? Theme.of(context).primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message.time,
                          style: TextStyle(
                            fontSize: 10,
                            color: isMe ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Message input
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: () {
                  // Attachment action
                },
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  // Send message action
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatDetailScreen(dynamic contact) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(contact.senderAvatar),
              radius: 16,
            ),
            const SizedBox(width: 8),
            Text(contact.senderName),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: _buildChatDetail(contact),
    );
  }

  void _startNewConversation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('New Message'),
            content: const Text(
              'This feature would allow you to start a new conversation.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }
}
