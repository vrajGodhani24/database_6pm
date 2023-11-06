import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'views/homepage.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
      ],
    ),
  );
}
