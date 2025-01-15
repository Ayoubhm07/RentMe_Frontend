import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationTile extends StatelessWidget {
  final String title;
  final String body;
  final String formattedTime;
  final String imageUrl;

  const NotificationTile({
    Key? key,
    required this.title,
    required this.body,
    required this.formattedTime,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Add your dismissal logic here
      },
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you wish to delete this notification?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Delete"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
                  Text(formattedTime, style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                ],
              ),
              SizedBox(height: 8.0),
              Text(title, style: GoogleFonts.roboto(fontSize: 16.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 4.0),
              Text(body, style: GoogleFonts.roboto(fontSize: 14.0, color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}
