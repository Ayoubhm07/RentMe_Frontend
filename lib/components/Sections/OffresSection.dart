import 'package:dynamic_multi_step_form/dynamic_multi_step_form.dart';

import '../../Services/UserService.dart';
import '../../entities/Offre.dart';
import '../../entities/User.dart';

class OffersSection extends StatefulWidget {
  final List<Offre> offers;

  OffersSection({Key? key, required this.offers}) : super(key: key);

  @override
  _OffersSectionState createState() => _OffersSectionState();
}

class _OffersSectionState extends State<OffersSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset('assets/images/offers.png', fit: BoxFit.contain),
            ),
            title: Text('Offers', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            height: isExpanded ? null : 0,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.offers.length,
              itemBuilder: (context, index) {
                return FutureBuilder<User>(
                  future: UserService().findUserById(widget.offers[index].userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return buildOfferItem(widget.offers[index], snapshot.data!);
                    } else {
                      return Text("User data not available.");
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOfferItem(Offre offre, User user) {
    print(user);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5.0,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage("assets/images/user1.png"),
            radius: 30,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                user.roles, // Assuming `role` exists in the User entity
                style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.star, color: Colors.amber, size: 20.0),
                SizedBox(width: 4),
                Text("4.95 (65 reviews)", style: TextStyle(fontSize: 14.0)),
              ],
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "€${offre.price}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "${offre.periode}",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}