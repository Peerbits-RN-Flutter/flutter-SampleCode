import '../../../ApiFactory/Models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../PBEmptyView.dart';
import '../../PBMainContainer.dart';
//import 'package:company/src/Authentication/Controllers/LoginController.dart';
import '../Views/Widgets/ChatWidget.dart';
import '../../../Config/Localization/Localize.dart';
import '../../../Config/Extension.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get/get.dart';

class ChatsView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatsView> {
  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return PBMainContainer(
      elevation: 0.5,
      padding: 16.0,
      appBarTitle: Localize.chat.tr,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(KcurrentUser.value!.id.toString().setChatId)
            .collection("UserChats")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: MediaQuery.of(context).size.height / 2 + 250,
              child: PBEmptyView(
                errorMsg: Localize.no_data_found.tr,
              ),
            );
          } else {
            if (snapshot.data!.docs.length > 0) {
              return ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(snapshot.data!.docs[index]);
                  });
            } else {
              return Container(
                height: MediaQuery.of(context).size.height / 2 + 250,
                child: PBEmptyView(
                  errorMsg: Localize.no_data_found.tr,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
