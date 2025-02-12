import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/entities/Conversation.dart';
import 'package:khedma/entities/Message.dart';
import 'package:khedma/screens/ChatMessage.dart';
import 'package:khedma/screens/SideMenu.dart';
import 'package:khedma/Services/ConversationAndMessageService.dart';
import 'package:khedma/components/appBar/appBar.dart';
import 'package:khedma/entities/LastMessage.dart';
import 'package:khedma/entities/User.dart';
import 'package:khedma/Services/ProfileService.dart';
import 'package:khedma/Services/MinIOService.dart';
import 'dart:io';

class MessagePage extends StatefulWidget {
  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool _isSettingsDrawer = false;
  List<ConversationWithLastMessage> conversations = [];
  late ConversationAndMessageService conversationAndMessageService;
  late SharedPrefService sharedPrefService;
  late UserService userService;
  late ProfileService profileService;
  late MinIOService minIOService;
  User? user;
  Map<int, User> receivers = {};
  Map<int, String?> receiverImages = {};

  @override
  void initState() {
    super.initState();
    sharedPrefService = SharedPrefService();
    conversationAndMessageService = ConversationAndMessageService();
    userService = UserService();
    profileService = ProfileService();
    minIOService = MinIOService();
    loadConversationsWithLastMessage();
  }

  void loadConversationsWithLastMessage() async {
    user = await sharedPrefService.getUser();
    print('currentUserId: ${user?.id}');
    conversations = await conversationAndMessageService.getConversationsWithLastMessageByUserId(user!.id ?? 0);
    print('conversations: $conversations');

    for (var conversation in conversations) {
      final receiverId = conversation.participantIds[0];
      final receiver = await userService.findUserById(receiverId);
      receivers[receiverId] = receiver;
      final imageUrl = await _fetchUserProfileImage(receiverId);
      receiverImages[receiverId] = imageUrl;
    }

    setState(() {});
  }

  Future<String?> _fetchUserProfileImage(int userId) async {
    try {
      final profileDetails = await profileService.getProfileDetails(userId);
      if (profileDetails.profilePicture != null) {
        String objectName = profileDetails.profilePicture!.replaceFirst('images_', '');
        return await minIOService.LoadFileFromServer('images', objectName);
      }
    } catch (e) {
      print('Failed to load user profile image: $e');
    }
    return null;
  }

  void _toggleDrawer(BuildContext context) {
    setState(() {
      _isSettingsDrawer = !_isSettingsDrawer;
    });
    Navigator.of(context).pop();
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: _isSettingsDrawer
          ? Builder(
        builder: (context) => SettingsDrawer(toggleDrawer: () => _toggleDrawer(context)),
      )
          : Builder(
        builder: (context) => MyDrawer(toggleDrawer: () => _toggleDrawer(context)),
      ),
      appBar: CustomAppBar(
        notificationIcon: Icon(Icons.notifications, color: Colors.white),
        title: 'Mes Messages',
        showSearchBar: false,
        backgroundColor: Color(0xFF0099D6),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                final lastMessage = conversation.lastMessage;
                final isCurrentUserMessage = lastMessage.senderId == user?.id;
                final receiverId = conversation.participantIds[0];
                final receiver = receivers[receiverId];
                final receiverImage = receiverImages[receiverId];

                if (receiver == null) {
                  return SizedBox.shrink();
                }

                return Column(
                  children: [
                    Slidable(
                      endActionPane: ActionPane(
                        motion: DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              // Define your action here
                            },
                            backgroundColor: Color(0xFF6295E2),
                            foregroundColor: Colors.white,
                            icon: Icons.phone,
                            label: 'Call',
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCurrentUserMessage
                              ? Colors.grey[100]
                              : Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatMessagePage(
                                  conversationId: conversation.id,
                                  receiver: receiver,
                                  currentUser: user!,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: receiverImage != null
                                      ? FileImage(File(receiverImage))
                                      : AssetImage("assets/images/user1.png") as ImageProvider,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            conversation.namePerUser,
                                            style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            '${lastMessage.deliveryTime.hour}:${lastMessage.deliveryTime.minute}',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        lastMessage.content,
                                        style: GoogleFonts.inter(
                                          fontWeight: isCurrentUserMessage
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black87,
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
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}