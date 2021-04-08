import 'package:get/get.dart';
import '../../../Config/AppImages.dart';
import '../Models/TutorialInfoModel.dart';
import '../../../Config/Localization/Localize.dart';

class TutorialsController extends GetxController {
  var selectedPageIndex = 0.obs;

  List<TutorialInfo> tutorialsPages = [
    TutorialInfo(
      title: Localize.tutorials_title1,
      description: Localize.tutorials_desc1,
      image: AppImages.img_tutorials1,
    ),
    TutorialInfo(
      title: Localize.tutorials_title2,
      description: Localize.tutorials_desc2,
      image: AppImages.img_tutorials2,
    ),
    TutorialInfo(
      title: Localize.tutorials_title3,
      description: Localize.tutorials_desc3,
      image: AppImages.img_tutorials3,
    )
  ];
}
