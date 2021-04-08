import 'dart:io';
import 'package:Common/common/ApiFactory/Models/UserModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Widgets/PBButton.dart';
import '../../../Widgets/PBLog.dart';
import '../../../Config/AppImages.dart';
import '../../../Config/AppFont.dart';
import '../../../Config/AppColors.dart';
import '../../../Config/Extension.dart';
import '../../../Config/Localization/Localize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../PBTextInput.dart';

class ChatDetailsView extends StatelessWidget {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;

  ChatDetailsView(
      {required this.receiverId,
      required this.receiverAvatar,
      required this.receiverName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(AppImages.ic_back),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 1.0,
        backgroundColor: Colors.white,
        title: Text(
          receiverName ?? "Chat",
          maxLines: 1,
          style: AppFont.Body1_Regular(),
        ),
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.all(12),
            child: receiverAvatar != null
                ? Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Icon(
                        Icons.person_outline,
                        color: AppColors.grey,
                        size: 32,
                      ),
                      imageUrl: receiverAvatar,
                      // width: 32.0,
                      // height: 32.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  )
                : Icon(
                    Icons.person_outline,
                    color: AppColors.grey,
                    size: 32,
                  ),
          )
        ],
      ),
      body: ChatScreen(
        receiverId: receiverId,
        receiverAvatar: receiverAvatar,
        receiverName: receiverName,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;

  ChatScreen(
      {required this.receiverId,
      required this.receiverAvatar,
      required this.receiverName});

  @override
  State createState() => ChatScreenState(
      receiverId: receiverId,
      receiverAvatar: receiverAvatar,
      receiverName: receiverName);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState(
      {required this.receiverId,
      required this.receiverAvatar,
      required this.receiverName});

  String receiverId = "";
  String receiverAvatar = "";
  String receiverName = "";
  String senderId = "";
  var counter = 0;

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = "";

  File? imageFile;
  bool isLoading = false;
  String imageUrl = "";

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    senderId = KcurrentUser.value!.id.toString().setChatId;

    //groupChatId = _getChatId(int.parse(senderId), int.parse(receiverId));
    groupChatId = _getChatId(senderId, receiverId);
    PBLog(groupChatId);
    isLoading = false;

    //for making an unread count 0 of sender
    FirebaseFirestore.instance
        .collection("users")
        .doc(senderId)
        .collection("UserChats")
        .doc(groupChatId)
        .update({
      'unreadCount': 0,
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("UserChats")
        .doc(groupChatId)
        .get()
        .then((value) => counter = value.data()!["unreadCount"]);
  }

  /*String _getChatId(int senderId, int receiverId) {
    List<int> chatIds = [senderId, receiverId];
    chatIds.sort();
    return chatIds.join("_");
  }*/
  String _getChatId(String senderId, String receiverId) {
    List<String> chatIds = [receiverId, senderId];
    //chatIds.sort();
    return chatIds.join("_");
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.removeListener(() {});
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
    }
  }

  void onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('chats')
          .doc(groupChatId)
          .collection("messages")
          .doc();

      //send message
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'toId': receiverId,
            'createdAt': DateTime.now().toUtc().millisecondsSinceEpoch,
            'content': content,
            'user': {
              '_id': senderId,
              'avatar': KcurrentUser.value?.image,
              'name': KcurrentUser.value?.company_name,
            }
          },
        );
      });

      //update the lastMessage of the sender
      FirebaseFirestore.instance
          .collection("users")
          .doc(senderId)
          .collection("UserChats")
          .doc(groupChatId)
          .set({
        'createdAt': DateTime.now().toUtc().millisecondsSinceEpoch,
        'id': receiverId,
        'image': receiverAvatar,
        'name': receiverName,
        'lastMessage': {
          'toId': receiverId,
          'createdAt': DateTime.now().toUtc().millisecondsSinceEpoch,
          'content': content,
          'user': {
            '_id': senderId,
            'avatar': KcurrentUser.value?.image,
            'name': KcurrentUser.value?.company_name,
          },
        },
        'unreadCount': 0,
      });

      //update the lastMessage of the receiver
      FirebaseFirestore.instance
          .collection("users")
          .doc(receiverId)
          .collection("UserChats")
          .doc(groupChatId)
          .set({
        'createdAt': DateTime.now().toUtc().millisecondsSinceEpoch,
        'id': senderId,
        'image': KcurrentUser.value?.image,
        'name': KcurrentUser.value?.company_name,
        'lastMessage': {
          'toId': receiverId,
          'createdAt': DateTime.now().toUtc().millisecondsSinceEpoch,
          'content': content,
          'user': {
            '_id': senderId,
            'avatar': KcurrentUser.value?.image,
            'name': KcurrentUser.value?.company_name,
          },
        },
        'unreadCount': counter = counter + 1,
      });

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      //showSnackBar(message: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document.data()!['user']["_id"] == senderId) {
      // Right (my message)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  child: Text(
                    document.data()!['content'],
                    style: AppFont.Body2_Regular(color: Colors.white),
                  ),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: AppColors.blueDotColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(right: 10.0, bottom: 5.0),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          // Time
          isLastMessageRight(index)
              ? Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    DateFormat.jm().format(
                      DateTime.fromMillisecondsSinceEpoch(
                        document.data()!['createdAt'],
                      ),
                    ),
                    style: AppFont.Body2_Regular(
                        color: AppColors.lightGrey, size: 10.0),
                  ),
                  margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                )
              : Container()
        ],
      );
    } else {
      // Left (peer message)
      return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.blueDotColor),
                      ),
                      width: 16.0,
                      height: 16.0,
                      padding: EdgeInsets.all(10.0),
                    ),
                    imageUrl: receiverAvatar,
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                Flexible(
                  child: Container(
                    child: Text(
                      document.data()!['content'],
                      style: AppFont.Body2_Regular(),
                    ),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0),
                  ),
                ),
              ],
            ),
            // Time
            isLastMessageRight(index)
                ? Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      DateFormat.jm().format(
                        DateTime.fromMillisecondsSinceEpoch(
                          document.data()!['createdAt'],
                        ),
                      ),
                      style: AppFont.Body2_Regular(
                          color: AppColors.lightGrey, size: 10.0),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()!['user']["_id"] == senderId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()!['user']["_id"] != senderId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            // List of messages
            buildListMessage(),
            // Input content
            buildInput(),
          ],
        ),

        /*// Loading
        buildLoading()*/
      ],
    );
  }

  Widget buildInput() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: PBTextInput(
        onFieldSubmitted: (text) {
          onSendMessage(textEditingController.text);
        },
        /*prefix: IconButton(
          icon: Icon(Icons.tag_faces_outlined),
          onPressed: () {
            FocusScope.of(context).requestFocus(focusNode);
          },
          color: AppColors.grey,
        ),*/
        suffix: PBButton(
          isForSend: true,
          color: AppColors.blueDotColor,
          child: Image.asset(AppImages.ic_send),
          onPress: () {
            onSendMessage(textEditingController.text);
          },
        ),
        textInputAction: TextInputAction.newline,
        focusNode: focusNode,
        borderRadius: BorderRadius.circular(10.0),
        controller: textEditingController,
        textInputType: TextInputType.multiline,
        hintText: Localize.type_a_message.tr,
      ),
      width: double.infinity,
      //height: 80.0,
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
              ),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(groupChatId)
                  .collection("messages")
                  .orderBy('createdAt', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.orange),
                    ),
                  );
                } else {
                  listMessage.addAll(snapshot.data!.docs);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data!.docs[index]),
                    itemCount: snapshot.data!.docs.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
