import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

import '../constants.dart';
import '../controllers/storage.dart';
import '../models/contacts.dart';
import '../widgets/contact_card.dart';
import 'select_access.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  final StorageController _storageController = StorageController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // fetchContacts();
  }

  Future<List<ContactsModel>> fetchContacts() async {
    return _storageController.readContacts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton.large(
            backgroundColor: appBarColour,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add_alt, size: 30, color: backGroundColour),
              ],
            ),
            onPressed: () async {
              Contact? contact = await _contactPicker.selectContact();
              if (contact != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccessRequestPage(
                              name: contact.fullName!,
                            )));
              } else {}
            }),
      ),
      key: scaffoldKey,
      backgroundColor: whiteColour,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          iconTheme: IconThemeData(color: appBarColour),
          backgroundColor: backGroundColour,
          automaticallyImplyLeading: false,
          title: Text(
            "CONTACTS",
            style: TextStyle(
                color: appBarColour, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(
            //   height: 10,
            // ),
            FutureBuilder(
                future: fetchContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                        color: backGroundColourDark);
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("ERROR: ${snapshot.error}"));
                  }
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ContactsCard(
                          contactsDetails: snapshot.data![index],
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}
