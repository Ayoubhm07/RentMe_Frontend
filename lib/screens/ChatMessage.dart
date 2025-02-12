import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/MessagesService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/components/navbara.dart';
import 'package:khedma/screens/SideMenu.dart';
import 'package:khedma/theme/AppTheme.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../Services/MinIOService.dart';
import '../Services/ProfileService.dart';
import '../components/appBar/appBar.dart';
import '../entities/Message.dart';
import '../entities/ProfileDetails.dart';
import '../entities/User.dart';
import 'CallScreen.dart';

class ChatMessagePage extends StatefulWidget {
  final int conversationId;
  final User receiver;
  final User currentUser;

  ChatMessagePage({required this.conversationId, required this.receiver, required this.currentUser});

  @override
  _ChatMessagePageState createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {
  String buttonImagePath = 'assets/icons/deal.png';
  String selectedProviderMessage = '';
  List<Widget> chatMessages = [];
  List<Message> messages = [];
  late MessageService messageService;
  late SharedPrefService sharedPrefService;
  late WebSocketChannel channel;
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  final ProfileService profileService = ProfileService();
  final MinIOService minIOService = MinIOService();
  String? userImage, currentUserImage;

  @override
  void initState() {
    super.initState();
    messageService = MessageService();
    sharedPrefService = SharedPrefService();
    _loadMessages();
    _connectWebSocket();
    _fetchUserProfileImage();
    _fetchCurrentUserProfileImage();
  }

  Future<void> _fetchUserProfileImage() async {
    try {
      ProfileDetails profileDetails = await profileService.getProfileDetails(widget.receiver.id ?? 0);
      String objectName = profileDetails.profilePicture!.replaceFirst('images_', '');
      String filePath = await minIOService.LoadFileFromServer('images', objectName);
      setState(() {
        userImage = filePath;
      });
    } catch (e) {
      print('Failed to load user profile image: $e');
    }
  }

  Future<void> _fetchCurrentUserProfileImage() async {
    try {
      ProfileDetails profileDetails = await profileService.getProfileDetails(widget.currentUser.id ?? 0);
      String objectName = profileDetails.profilePicture!.replaceFirst('images_', '');
      String filePath = await minIOService.LoadFileFromServer('images', objectName);
      setState(() {
        currentUserImage = filePath;
      });
    } catch (e) {
      print('Failed to load user profile image: $e');
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    isLoading = true;
    messages = await messageService.fetchMessagesByConversationId(widget.conversationId);
    setState(() {
      isLoading = false;
      _scrollToBottom();
    });
  }

  void _connectWebSocket() async {
    String accessToken = await sharedPrefService.readStringFromPrefs('accessToken');
    String username = widget.currentUser.userName!;
    String conversationId = widget.conversationId.toString();

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Username': username,
      'UserId': widget.currentUser.id,
      'ConversationId': conversationId,
    };

    channel = IOWebSocketChannel.connect(
      Uri.parse('ws://localhost:8080/chat'),
      headers: headers,
    );
    channel.stream.listen((message) {
      print('Received message: $message');
      setState(() {
        try {
          final Map<String, dynamic> parsedMessage = json.decode(message);
          print(parsedMessage['content']);
          Map<String, dynamic> messageMap = {
            'id': '0',
            'content': parsedMessage['content'],
            'senderId': parsedMessage['senderId'],
            'deliveryTime': DateTime.now().toIso8601String(),
          };
          messages.add(Message.fromJson(messageMap));
          _scrollToBottom();
        } catch (e) {
          print('Error parsing message: $e');
        }
      });
    });
  }

  void _sendMessage(String content) {
    if (content.isNotEmpty) {
      final message = Message(
        id: '0',
        content: content,
        senderId: widget.currentUser.id.toString(),
        deliveryTime: DateTime.now(),
      );
      print(message.toJson());
      channel.sink.add(JsonEncoder().convert(message.toJson()));
      setState(() {
        messages.add(message);
        _controller.clear();
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA), // Fond doux et professionnel
      body: Column(
        children: [
          // En-tête
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(
              color: Color(0xFF2E3A4B), // Bleu foncé pour l'en-tête
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Photo de profil du destinataire
                CircleAvatar(
                  radius: 20,
                  backgroundImage: userImage != null
                      ? FileImage(File(userImage!))
                      : AssetImage("assets/images/user1.png") as ImageProvider,
                ),
                SizedBox(width: 10),
                // Nom du destinataire
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.receiver.firstName} ${widget.receiver.lastName}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                // Boutons d'appel
                Row(
                  children: [
                    ZegoSendCallInvitationButton(
                      isVideoCall: false,
                      buttonSize: Size(50, 50),
                      iconSize: Size(30, 30),
                      resourceID: "zegouikit_call",
                      invitees: [
                        ZegoUIKitUser(
                          id: widget.receiver.id.toString(),
                          name: widget.receiver.userName!,
                        )
                      ],
                    ),
                    SizedBox(width: 10),
                    ZegoSendCallInvitationButton(
                      isVideoCall: true,
                      buttonSize: Size(50, 50),
                      iconSize: Size(30, 30),
                      resourceID: "zegouikit_call",
                      invitees: [
                        ZegoUIKitUser(
                          id: widget.receiver.id.toString(),
                          name: widget.receiver.userName!,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Zone de messages
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSentByUser = int.parse(message.senderId) == widget.currentUser.id;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isSentByUser)
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: userImage != null
                              ? FileImage(File(userImage!))
                              : AssetImage("assets/images/user1.png") as ImageProvider,
                        ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSentByUser ? Color(0xFF007AFF) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Text(
                          message.content,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSentByUser ? Colors.white : Color(0xFF2E3A4B),
                          ),
                        ),
                      ),
                      if (isSentByUser)
                        SizedBox(width: 8),
                      if (isSentByUser)
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: currentUserImage != null
                              ? FileImage(File(currentUserImage!))
                              : AssetImage("assets/images/user1.png") as ImageProvider,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Zone de saisie de message
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Écrire un message...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: Color(0xFFCDCFCE),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF8F9FA),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF34C759),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}