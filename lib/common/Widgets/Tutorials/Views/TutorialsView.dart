import '../../../Config/AppFont.dart';
import '../../../Config/AppColors.dart';
//import 'package:company/src/Authentication/Views/AuthMainView.dart';
import '../Controllers/TutorialsController.dart';
import '../../../Config/Localization/Localize.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get/get.dart';

class Tutorials extends StatelessWidget {
  final _tutorialsController = TutorialsController();

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    return Scaffold(
      backgroundColor: AppColors.blueBgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Expanded(
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      child: PageView.builder(
                        onPageChanged: _tutorialsController.selectedPageIndex,
                        itemCount: _tutorialsController.tutorialsPages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  _tutorialsController
                                          .tutorialsPages[index].image ??
                                      "",
                                  height:
                                      MediaQuery.of(context).size.height <= 570
                                          ? 200
                                          : 295,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _tutorialsController
                                      .tutorialsPages[index].title!.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 30,
                                    fontFamily: AppFont.Roboto_Bold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  _tutorialsController
                                      .tutorialsPages[index].description!.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: AppFont.Roboto_Regular,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _tutorialsController.tutorialsPages.length,
                          (index) => Obx(
                            () {
                              return Container(
                                height: 8,
                                width: 8,
                                margin: EdgeInsets.only(
                                    top: 16.0, right: 8.0, left: 8.0),
                                decoration: BoxDecoration(
                                  color: _tutorialsController
                                              .selectedPageIndex.value ==
                                          index
                                      ? AppColors.orange
                                      : AppColors.greyDotColor,
                                  shape: BoxShape.circle,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 35,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: MaterialButton(
                      height: 55,
                      onPressed: () {
                        //Get.offAll(AuthenticationMain(Const.SIGNUP));
                      },
                      child: Text(
                        Localize.signup.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: AppFont.Roboto_Regular,
                            fontWeight: FontWeight.w500),
                      ),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 9,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: MaterialButton(
                        color: Colors.white,
                        onPressed: () {
                          //Get.offAll(AuthenticationMain(Const.SIGNIN));
                        },
                        child: Text(
                          Localize.signin.tr,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 17,
                            fontFamily: AppFont.Roboto_Regular,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        textColor: AppColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
