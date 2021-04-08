import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../Config/AppImages.dart';
import '../../../../Config/AppFont.dart';
import '../../../../Config/AppColors.dart';
import '../ChatDetailsView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatWidget extends StatefulWidget {
  DocumentSnapshot document;

  ChatWidget(this.document);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          ChatDetailsView(
            receiverId: widget.document.data()!["id"],
            receiverAvatar: widget.document.data()!["image"],
            receiverName: widget.document.data()!["name"],
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.only(bottom: 13.0),
        //height: 80,
        //width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            style: BorderStyle.solid,
            color: AppColors.borderColor,
          ),
        ),
        child: Row(
          children: [
            widget.document.data()!["image"] != null
                ? Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Icon(
                        Icons.person_outline,
                        color: AppColors.grey,
                        size: 32,
                      ),
                      imageUrl: widget.document.data()!["image"],
                      width: 48.0,
                      height: 48.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  )
                : Icon(
                    Icons.person_outline,
                    color: AppColors.grey,
                    size: 32,
                  ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.document.data()!["name"] ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppFont.SubTitle1_Medium(),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.document.data()!["lastMessage"]["content"] ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppFont.Body1_Regular(color: AppColors.grey),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: widget.document.data()!["unreadCount"] == 0
                  ? SizedBox()
                  : Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.badgeColor,
                      ),
                      child: Center(
                        child: Text(
                          widget.document.data()!["unreadCount"].toString(),
                          style: AppFont.Body1_Regular(color: Colors.white),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
