//we will use this to fill the list of this class instance in the provider for news

import 'package:flutter/foundation.dart';

class newsData {
  final String UrltoMore;
  final String ImageToUrl;
  final String desc;
  final String title;

  newsData(
      {required this.UrltoMore,
      required this.ImageToUrl,
      required this.desc,
      required this.title});
}
