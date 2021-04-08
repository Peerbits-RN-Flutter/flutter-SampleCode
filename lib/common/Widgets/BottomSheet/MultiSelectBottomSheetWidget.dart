import '../../config/AppColors.dart';
import '../../config/AppFont.dart';
import '../../config/AppImages.dart';
import '../../ApiFactory/Models/BaseList.dart';
import 'BottomSheetController.dart';
import '../../Config/Localization/Localize.dart';
import '../../Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiSelectBottomSheetWidget extends StatefulWidget {
  List<BaseListModel> list = [];
  String title;

  MultiSelectBottomSheetWidget(this.list, this.title);

  @override
  _MultiSelectBottomSheetWidgetState createState() =>
      _MultiSelectBottomSheetWidgetState();
}

class _MultiSelectBottomSheetWidgetState
    extends State<MultiSelectBottomSheetWidget> {
  final _controller = Get.put(BottomSheetController());

  @override
  void initState() {
    super.initState();
    _controller!.list.assignAll(widget.list);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 4,
            color: AppColors.greyDotColor,
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(AppImages.chevron_left),
              ),
              SizedBox(
                width: 25,
              ),
              Text(
                widget.title,
                style: AppFont.Title_H6_Medium(),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 41,
                    //width: 75,
                    child: MaterialButton(
                      elevation: 0.0,
                      color: AppColors.blueButtonColor,
                      onPressed: () {
                        var selectedItems = _controller!.list
                            .where((e) => e.isSelected)
                            .toList();
                        if (selectedItems.length == 0) {
                          showWarning(Localize.selectAnyItem.tr);
                        } else {
                          Get.back(result: selectedItems);
                        }
                      },
                      child: Text(
                        Localize.done.tr,
                        style: AppFont.Body1_Regular(color: Colors.white),
                      ),
                      textColor: AppColors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Obx(
              () {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: _controller!.list.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _controller!.list[index].name ?? "",
                              style: AppFont.Body1_Regular(
                                  color: _controller!.list[index].isSelected
                                      ? AppColors.blueDotColor
                                      : AppColors.black),
                            ),
                            _controller!.list[index].isSelected
                                ? Image.asset(AppImages.ic_checkmark)
                                : SizedBox()
                          ],
                        ),
                        onTap: () {
                          _controller!.list[index].isSelected =
                              !_controller!.list[index].isSelected;
                          _controller!.list.refresh();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
