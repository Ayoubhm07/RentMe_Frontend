import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/MessagesService.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/components/navbara.dart';
import 'package:khedma/screens/SideMenu.dart';
import 'package:khedma/theme/AppTheme.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../components/appBar/appBar.dart';
import '../entities/Message.dart';
import '../entities/User.dart';
import 'CallScreen.dart';

class ChatMessagePage extends StatefulWidget {
  final int conversationId;
  final User receiver;
  final User currentUser;

  ChatMessagePage({required this.conversationId , required this.receiver , required this.currentUser});

  @override
  _ChatMessagePageState createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {
  String buttonImagePath = 'assets/icons/deal.png';
  String selectedProviderMessage = '';
  List<Widget> chatMessages = []; // ListView starts empty
  List<Message> messages = [];
  late MessageService messageService;
  late SharedPrefService sharedPrefService;
  late WebSocketChannel channel;
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    messageService = MessageService();
    sharedPrefService = SharedPrefService();
    _loadMessages();
    _connectWebSocket();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    isLoading = true;
    messages = await messageService
        .fetchMessagesByConversationId(widget.conversationId);
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
      Uri.parse('ws://localhost:8080/chat'), // Replace with your WebSocket URL
      headers: headers,
    );
    channel.stream.listen((message) {
      // Handle incoming messages
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
          // Handle parsing error
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

  Widget _buildCompletionMessage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Dr. Floyd Miles a classifier votre demande comme étant terminée, est-ce que vous confirmez cette affirmation ?',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  chatMessages.add(Text(""));
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: Text(
                'Valider',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: Text(
                'Annuler',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool _isSettingsDrawer = false;

  void _toggleDrawer(BuildContext context) {
    setState(() {
      _isSettingsDrawer = !_isSettingsDrawer;
    });
    Navigator.of(context).pop(); // Close the current drawer
    Scaffold.of(context).openEndDrawer(); // Open the new drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFEFF6F9),
      endDrawer: _isSettingsDrawer
          ? Builder(
        builder: (context) =>
            SettingsDrawer(toggleDrawer: () => _toggleDrawer(context)),
      )
          : Builder(
        builder: (context) =>
            MyDrawer(toggleDrawer: () => _toggleDrawer(context)),
      ),
      appBar: CustomAppBar(
        notificationIcon: Icon(Icons.location_on_outlined, color: Colors.white),
        title: 'Messages',
        showSearchBar: false,
        backgroundColor: AppTheme.primaryColor, // AppBar with primary color
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 50),
            decoration: BoxDecoration(
              color: Color(0xFF0099D6),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(17, 29, 18.6, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/icons/Dr.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 3.8),
                                  child: Text(
                                    // make the first letter of the receiver name upper case
                                    '${widget.receiver.firstName.toUpperCase()} ${widget.receiver.lastName}',
                                    style: GoogleFonts.getFont(
                                      'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.7,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 3.5),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF66CA98),
                                        borderRadius:
                                        BorderRadius.circular(3.5),
                                      ),
                                      width: 7,
                                      height: 7,
                                    ),
                                    Text(
                                      'Online',
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.2,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),// Use Spacer to push the icons to the right
                        ZegoSendCallInvitationButton(
                          isVideoCall: false,
                          buttonSize: new Size(60, 60),
                          iconSize: new Size(40, 40),
                          //You need to use the resourceID that you created in the subsequent steps.
                          //Please continue reading this document.
                          resourceID: "zegouikit_call",
                          invitees: [
                            ZegoUIKitUser(
                              id: widget.receiver.id.toString(),
                              name: widget.receiver.userName!,
                            )
                          ],
                        ),
                        ZegoSendCallInvitationButton(
                          isVideoCall: true,
                          buttonSize: new Size(60, 60),
                          iconSize: new Size(40, 40),
                          //You need to use the resourceID that you created in the subsequent steps.
                          //Please continue reading this document.
                          resourceID: "zegouikit_call",
                          invitees: [
                            ZegoUIKitUser(
                              id: widget.receiver.id.toString(),
                              name: widget.receiver.userName!,
                            )
                          ],
                        ),
                        //_buildIcon('assets/icons/ep_more.png'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading // Show loading indicator if loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSentByUser =
                    int.parse(message.senderId) == widget.currentUser.id;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  // Add vertical padding
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isSentByUser) Spacer(),
                      if (isSentByUser)
                        Container(
                          width: 20,
                          height: 20,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/icons/Dr.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isSentByUser
                              ? Color(0xFF6295E2)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: 229.88,
                          minHeight: 46.25,
                        ),
                        child: Text(
                          message.content,
                          style: GoogleFonts.getFont(
                            'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSentByUser
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      if (!isSentByUser)
                        Container(
                          width: 20,
                          height: 20,
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/icons/Dr.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, right: 10 , left: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 41.97,
                    height: 41.97,
                    decoration: BoxDecoration(
                      color: Color(0xFF0099D5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Image.asset(
                        buttonImagePath,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Write a message',
                        hintStyle: TextStyle(
                          color: Color(0xFFCDCFCE),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 41.97,
                  height: 41.97,
                  decoration: BoxDecoration(
                    color: Color(0xFF0AA655),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () => _sendMessage(_controller.text),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildIcon(String assetPath) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.9),
      width: 49.8,
      height: 58.8,
      padding: EdgeInsets.all(9.2),
      child: Image.asset(assetPath),
    );
  }
}