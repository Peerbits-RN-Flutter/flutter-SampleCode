import '../../config/Localization/en.dart';
import '../../config/Localization/pt.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'en': EN.Lang(),
        'pt': PT.Lang(),
      };
}
