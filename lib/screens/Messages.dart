import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/SharedPrefService.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/entities/Conversation.dart';
import 'package:khedma/screens/ChatMessage.dart';
import 'package:khedma/screens/SideMenu.dart';

import '../Services/ConversationAndMessageService.dart';
import '../entities/User.dart';


class MessagePage extends StatefulWidget {
  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool _isSettingsDrawer = false;
  List<Conversation> conversations = [];
  late ConversationAndMessageService conversationAndMessageService;
  late SharedPrefService sharedPrefService;
  late UserService userService;
  User? user;
  List<User> receivers = [];


  @override
  void initState() {
    super.initState();
    sharedPrefService = SharedPrefService();
    sharedPrefService.checkAllValues();
    conversationAndMessageService = ConversationAndMessageService();
    userService = UserService();
    // Fetch the user's conversations
    loadConversations();


  }



  void loadConversations() async {
    // get current user id from shared pref
    user = await sharedPrefService.getUser();
    print("feljdid");
    print('currentUserId: ${user?.id}');
    conversations = await conversationAndMessageService.FetchUserConversation(user!.id ?? 0);
    print('conversations: $conversations');
    for(int i = 0; i < conversations.length; i++){
      receivers.add(await userService.getUserById(conversations[i].namePerUser));
      print('receiver: ${receivers[i]}');
    }
    setState(() {});
  }

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
      backgroundColor: Colors.white,
      endDrawer: _isSettingsDrawer
          ? Builder(
        builder: (context) =>
            SettingsDrawer(toggleDrawer: () => _toggleDrawer(context)),
      )
          : Builder(
        builder: (context) =>
            MyDrawer(toggleDrawer: () => _toggleDrawer(context)),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF0099D6),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 24,
              height: 24,
              child: Image.asset(
                'assets/icons/notification.png',
                width: 24,
                height: 24,
              ),
            ),
            Text(
              'Mes Messages',
              style: GoogleFonts.getFont(
                'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 24),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
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
                    decoration: BoxDecoration(
                      color: Color(0xFFEDF4FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(14.2, 9.3, 10, 7.6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 12.6, 0),
                                width: 31,
                                height: 31,
                                child: Image.asset(
                                  'assets/drawericons/recherche.png',
                                  width: 19.2,
                                  height: 19.1,
                                ),
                              ),
                              Text(
                                'Recherche',
                                style: GoogleFonts.getFont(
                                  'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xFFB7B7B7),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            child: Image.asset(
                              'assets/drawericons/Close.png',
                              width: 12,
                              height: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(28, 0, 28, 10.7),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                final receiver = receivers[index];
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
                      color: Color.fromARGB(255, 192, 225, 251),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        print("going messages");
                        // navigate to chatmessages
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatMessagePage(conversationId: conversation.id , receiver: receiver , currentUser:this.user!),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 50),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  width: 40,
                                  height: 40,
                                  child: Image.asset(
                                    'assets/images/user1.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        11.8, 14.3, 11.8, 14.7),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0.9),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    conversation.namePerUser,
                                                    style: GoogleFonts.getFont(
                                                      'Roboto',
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 14.3,
                                                      color: Color(0xFF1C1F1E),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '8:01', // Replace with actual time if available
                                                        style:
                                                        GoogleFonts.getFont(
                                                          'Inter',
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 10.7,
                                                          color:
                                                          Color(0xFFA7A6A5),
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, 6.8, 5.5),
                                          child: Text(
                                            'Mechanic', // Replace with actual role if available
                                            style: GoogleFonts.getFont(
                                              'Inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.5,
                                              color: Color(0xFFA7A6A5),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                          EdgeInsets.fromLTRB(0, 0, 6.8, 0),
                                          child: Text(
                                            'Vivamus varius odio non dui gravida, qui...', // Replace with actual message if available
                                            // make go back to line if needed
                                            maxLines: 1,
                                            style: GoogleFonts.getFont(
                                              'Inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10.7,
                                              color: Color(0xFFA7A6A5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFFF6C52),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding:
                                EdgeInsets.fromLTRB(4.5, 0.9, 4.9, 2.2),
                                child: Text(
                                  '3', // Replace with actual unread count if available
                                  style: GoogleFonts.getFont(
                                    'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.7,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ),
                  SizedBox(height: 10), // Add spacing between items
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