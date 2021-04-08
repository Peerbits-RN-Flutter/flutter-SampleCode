import '../Widgets/PBLog.dart';
import '../config/AppColors.dart';
import '../config/AppFont.dart';
import '../config/AppImages.dart';
import '../config/prefs/PrefUtils.dart';
import '../ApiFactory/Models/BaseList.dart';
import '../Widgets/BottomSheet/MultiSelectBottomSheetWidget.dart';
import '../Config/Localization/Localize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> ackAlert(
  BuildContext context,
  String title,
  String content,
  VoidCallback onPressed,
) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        titleTextStyle: TextStyle(
          fontFamily: AppFont.Roboto_Regular,
          fontSize: 21,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        content: Text(content),
        contentTextStyle: TextStyle(
          fontFamily: AppFont.Roboto_Regular,
          fontSize: 17,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              Localize.done.tr,
              style: TextStyle(
                fontFamily: AppFont.Roboto_Regular,
                fontSize: 17,
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onPressed,
          ),
        ],
      );
    },
  );
}

// Widget loadingWidget() {
//   PBLog("loadingWidget");
//   return Container(
//     color: Color(0x88888888),
//     width: double.infinity,
//     height: double.infinity,
//     child: Center(
//       child: CircularProgressIndicator(
//         strokeWidth: 10.0,
//       ),
//     ),
//   );
// }

showLoading() {
  Get.dialog(
    Center(
      child: SizedBox(
        child: FittedBox(child: CircularProgressIndicator()),
        height: 50.0,
        width: 50.0,
      ),
    ),
    barrierDismissible: false,
  );
}

hideLoading() {
  Get.back();
}

void showSnackBar(
    {title,
    message,
    SnackPosition? snackPosition,
    Color? backgroundColor,
    Duration? duration}) {
  Get.showSnackbar(
    GetBar(
      title: title,
      message: message,
      duration: duration ?? Duration(seconds: 2),
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      backgroundColor: backgroundColor ?? Colors.black87,
    ),
  );
}

handleApiError(errorMessage) {
  showSnackBar(backgroundColor: Colors.redAccent, message: errorMessage);
}

showWarning(message) {
  showSnackBar(backgroundColor: Colors.blueAccent, message: message);
}

bool validatePassword(String password) {
  return RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~?]).{8,}$')
      .hasMatch(password);
}

bool validateEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

bool validURL(String url) {
  return Uri.parse(url).isAbsolute;
  //var urlPattern = r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
  //var urlPattern = r"(http|https?)://(www.)?[a-zA-Z0-9@:%._\\+~#?&//=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%._\\+~#?&//=]*)";
  //var match = RegExp(urlPattern, caseSensitive: false).hasMatch(url);
  //PBLog(match);
  //return false;
}

typedef OnItemsSelected(BaseListModel data);
typedef OnMultiItemSelected(List<BaseListModel> data);
typedef OnFilterSelected(String salary);

//MARK - Open single select bottomsheet -
//-----------------------------------
showCustomBottomSheet({
  @required List<BaseListModel>? list,
  @required String? title,
  @required OnItemsSelected? onItemsSelected,
  bool isMultiSelect = false,
}) {
  Get.bottomSheet(
    BottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
      ),
      onClosing: () {
        PBLog("on Close bottom sheet");
      },
      builder: (context) {
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
                    title ?? "",
                    style: AppFont.Title_H6_Medium(),
                  ),
                  isMultiSelect
                      ? Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 41,
                              width: 75,
                              child: MaterialButton(
                                elevation: 0.0,
                                color: AppColors.blueButtonColor,
                                onPressed: () {
                                  var isSelectedItems =
                                      list!.where((e) => e.isSelected).toList();
                                  if (isSelectedItems.length == 0) {
                                    showWarning(Localize.selectAnyItem.tr);
                                  } else {
                                    Get.back(result: isSelectedItems);
                                  }
                                },
                                child: Text(
                                  Localize.done.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                  ),
                                ),
                                textColor: AppColors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2 - 170,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: list!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 50,
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                list[index].name!,
                                style: AppFont.Body1_Regular(),
                              ),
                              // Image.asset(AppImages.ic_checkmark)
                              list[index].isSelected
                                  ? Image.asset(AppImages.ic_checkmark)
                                  : SizedBox()
                            ],
                          ),
                          onTap: () {
                            if (isMultiSelect) {
                              list[index].isSelected = !list[index].isSelected;
                            } else {
                              list[index].isSelected = !list[index].isSelected;
                              Get.back(result: list[index]);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    ),
  ).then((value) {
    FocusManager.instance.primaryFocus!.unfocus();
    onItemsSelected!(value);
    PBLog(value);
  });
}

//MARK - Open multi select bottomsheet -
//-----------------------------------
showMultiItemBottomSheet({
  List<BaseListModel>? list,
  @required String? title,
  @required OnMultiItemSelected? onMultiItemSelected,
}) {
  Get.bottomSheet(
    BottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
      ),
      onClosing: () {
        PBLog("on Close bottom sheet");
      },
      builder: (context) {
        return MultiSelectBottomSheetWidget(list ?? [], title ?? "");
      },
    ),
  ).then((value) {
    FocusManager.instance.primaryFocus!.unfocus();
    onMultiItemSelected!(value);
    PBLog(value);
  });
}

showSessionDialog() {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Text(
        Localize.sessionTimeout.tr,
        style: AppFont.Title_H4_Medium(),
      ),
      content: Text(
        Localize.sessionTimeoutMsg.tr,
        style: AppFont.Body2_Regular(),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            //Get.offAll(AuthenticationMain(Const.SIGNIN));
            //KcurrentUser.value = UserModel();
            PrefUtils.clearPrefs();
          },
          child: Text(
            Localize.signin.tr,
            style: AppFont.Body2_Regular(),
          ),
        ),
      ],
    ),
  );
}

//MARK - Enums -
//-----------------------------------
enum Enum_StatusOfEmployeements { Employee, Worker, Self_employed }

extension Enum_StatusOfEmployeement on Enum_StatusOfEmployeements {
  String? get name {
    switch (this) {
      case Enum_StatusOfEmployeements.Employee:
        return Localize.employee.tr;
      case Enum_StatusOfEmployeements.Worker:
        return Localize.worker.tr;
      case Enum_StatusOfEmployeements.Self_employed:
        return Localize.self_employed.tr;
      default:
        return null;
    }
  }
}

extension Enum_loadFromInt on int {
  Enum_StatusOfEmployeements? get initStatusofEmployeement {
    switch (this) {
      case 1:
        return Enum_StatusOfEmployeements.Employee;
      case 2:
        return Enum_StatusOfEmployeements.Worker;
      case 3:
        return Enum_StatusOfEmployeements.Self_employed;
      default:
        return null;
    }
  }
}

// ------- Gender Enums -----
enum Enum_Gender { Male, Female, Other }

extension Enum_Genders on Enum_Gender {
  String? get name {
    switch (this) {
      case Enum_Gender.Male:
        return Localize.male.tr;
      case Enum_Gender.Female:
        return Localize.female.tr;
      case Enum_Gender.Other:
        return Localize.other.tr;
      default:
        return null;
    }
  }
}

extension Enum_Genders_Int on int {
  Enum_Gender? get initGender {
    switch (this) {
      case 1:
        return Enum_Gender.Male;
      case 2:
        return Enum_Gender.Female;
      case 3:
        return Enum_Gender.Other;
      default:
        return null;
    }
  }
}

// ------- Proposal Status Enums -----
enum Enum_ProposalStatus { Pending, Accepted, NotInterested }

extension Enum_ProposalStatus_ on Enum_ProposalStatus {
  String? get name {
    switch (this) {
      case Enum_ProposalStatus.Pending:
        return Localize.pending.tr;
      case Enum_ProposalStatus.Accepted:
        return Localize.accepted.tr;
      case Enum_ProposalStatus.NotInterested:
        return Localize.not_interested.tr;
      default:
        return null;
    }
  }

  Color? get textColor {
    switch (this) {
      case Enum_ProposalStatus.Pending:
        return AppColors.grey;
      case Enum_ProposalStatus.Accepted:
        return AppColors.statusAccept;
      case Enum_ProposalStatus.NotInterested:
        return AppColors.statusNotAccept;
      default:
        return null;
    }
  }

  Color? get bgColor {
    switch (this) {
      case Enum_ProposalStatus.Pending:
        return Colors.white;
      case Enum_ProposalStatus.Accepted:
        return AppColors.statusAcceptBg;
      case Enum_ProposalStatus.NotInterested:
        return AppColors.statusNotAcceptBg;
      default:
        return null;
    }
  }
}

extension Enum_ProposalStatus_Int on int {
  Enum_ProposalStatus? get initProposalStatus {
    switch (this) {
      case 0:
        return Enum_ProposalStatus.Pending;
      case 1:
        return Enum_ProposalStatus.Accepted;
      case 2:
        return Enum_ProposalStatus.NotInterested;
      default:
        return null;
    }
  }
}

// ------- CMS Pages Enums -----
enum CMSPagesType { AboutUs, PrivacyPolicy, TermsAndCondition }

// ------- Notice periods Enums -----
enum Enum_NoticePeriods { Immediate, InAWeek, Month1, Months2 }

extension Enum_NoticePeriods_ on Enum_NoticePeriods {
  String? get name {
    switch (this) {
      case Enum_NoticePeriods.Immediate:
        return Localize.immediate.tr;
      case Enum_NoticePeriods.InAWeek:
        return Localize.in_a_week.tr;
      case Enum_NoticePeriods.Month1:
        return Localize.month1.tr;
      case Enum_NoticePeriods.Months2:
        return Localize.months2.tr;
      default:
        return null;
    }
  }
}

extension Enum_NoticePeriods_Int on int {
  Enum_NoticePeriods? get initNoticePeriods {
    switch (this) {
      case 1:
        return Enum_NoticePeriods.Immediate;
      case 2:
        return Enum_NoticePeriods.InAWeek;
      case 3:
        return Enum_NoticePeriods.Month1;
      case 4:
        return Enum_NoticePeriods.Months2;
      default:
        return null;
    }
  }
}

// ------- Notification periods Enums -----
enum Enum_Notification {
  accept_proposal,
  company_like,
  account_inactive,
  account_delete,
  chat
}

extension Enum_Notification_Int on String {
  Enum_Notification? get initNotification {
    switch (this) {
      case "accept_proposal":
        return Enum_Notification.accept_proposal;
      case "company_like":
        return Enum_Notification.company_like;
      case "account_inactive":
        return Enum_Notification.account_inactive;
      case "account_delete":
        return Enum_Notification.account_delete;
      case "chat":
        return Enum_Notification.chat;
      default:
        return null;
    }
  }
}
