import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khedma/Services/UserService.dart';
import 'package:khedma/entities/Conversation.dart';
import '../../entities/User.dart';
import '../../Services/ConversationAndMessageService.dart'; // Importez votre service
import '../ChatMessage.dart'; // Importez la page de chat

class ContactUser extends StatelessWidget {
  final int senderId;
  final int receiverId;
  const ContactUser({
    Key? key,
    required this.senderId,
    required this.receiverId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF0099D6),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Aligner les icônes à droite
        children: [
          _buildContactIcon(
            context,
            icon: Icons.message_rounded,
            color: Colors.white,
            onTap: () async {
              print("Message icon clicked");
              await _handleMessageClick(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleMessageClick(BuildContext context) async {
      try {
        User currentUser = await UserService().findUserById(senderId);
        User receiver = await UserService().findUserById(receiverId);
        print("CONVERSATIONNNNNN: $receiverId +++++++ $senderId");

        if (senderId == null || receiverId == null) {
          throw Exception("senderId ou receiverId est null");
        }

        ConversationAndMessageService service = ConversationAndMessageService();
        Conversation conversation = await service.createConversation(
          senderId,
          [receiverId],
        );

        print("Conversation créée: ${conversation.id}");
        int conversationId = conversation.id;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatMessagePage(
              conversationId: conversationId,
              receiver: receiver,
              currentUser: currentUser,
            ),
          ),
        );
      } catch (e) {
        print("Erreur lors de la création de la conversation: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de la création de la conversation: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  Widget _buildContactIcon(BuildContext context,
      {required IconData icon, required Color color, required VoidCallback onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 24,
            color: color,
          ),
        ),
      ),
    );
  }
}