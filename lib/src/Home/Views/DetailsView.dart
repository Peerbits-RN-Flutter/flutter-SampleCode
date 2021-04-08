import 'package:Common/common/ApiFactory/Models/BaseList.dart';
import 'package:Common/common/Utils/Utils.dart';
import 'package:Common/common/Widgets/Chats/Views/ChatsView.dart';
import 'package:Common/common/Widgets/DatePicker.dart';
import 'package:Common/common/Widgets/PBButton.dart';
import 'package:Common/common/Widgets/PBDrawer.dart';
import 'package:Common/common/Widgets/PBEmptyView.dart';
import 'package:Common/common/Widgets/PBLog.dart';
import 'package:Common/common/Widgets/PBMainContainer.dart';
import 'package:Common/common/Widgets/PBTextInput.dart';
import 'package:Common/common/Widgets/Tutorials/Views/TutorialsView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsView extends StatelessWidget {
  List<BaseListModel> listOfItems = [
    BaseListModel(id: 1, isSelected: false, name: "Apple"),
    BaseListModel(id: 2, isSelected: false, name: "Banana"),
    BaseListModel(id: 3, isSelected: false, name: "Mango"),
    BaseListModel(id: 4, isSelected: false, name: "Kiwi"),
    BaseListModel(id: 5, isSelected: false, name: "Grapes"),
    BaseListModel(id: 6, isSelected: false, name: "Watermalon"),
    BaseListModel(id: 7, isSelected: false, name: "Orange"),
  ];

  @override
  Widget build(BuildContext context) {
    return PBMainContainer(
      padding: 10.0,
      isAppBar: true,
      appBarTitle: "Details",
      actions: [IconButton(icon: Icon(Icons.exit_to_app), onPressed: () {})],
      child: Container(
        child: Column(
          children: [
            PBButton(
              onPress: () {
                DatePicker().show(
                  context: context,
                  onDateChange: (DateTime dateTime) {
                    PBLog(dateTime);
                  },
                  onTimeChange: (TimeOfDay dateTime) {
                    PBLog(dateTime);
                  },
                  datePickerMode: CustomeDatePickerMode.dateTime,
                );
              },
              child: Text(
                "Open DatePicker",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.apply(color: Colors.white),
              ),
              elevation: 10.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            PBButton(
              onPress: () {
                showCustomBottomSheet(
                  list: listOfItems,
                  title: "Sheet",
                  onItemsSelected: (BaseListModel item) {},
                );
              },
              child: Text(
                "Open BottomSheet",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.apply(color: Colors.white),
              ),
              elevation: 10.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            PBButton(
              onPress: () {
                showMultiItemBottomSheet(
                  list: listOfItems,
                  title: "Multi select",
                  onMultiItemSelected: (data) {},
                );
              },
              child: Text(
                "Open Multi-select BottomSheet",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.apply(color: Colors.white),
              ),
              elevation: 10.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            PBEmptyView(errorMsg: "Nothing to shoe"),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => Tutorials());
                },
                icon: Icon(Icons.pages_sharp),
                label: Text("Tutorials Page"),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => ChatsView());
                },
                icon: Icon(Icons.chat),
                label: Text("Chats"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
