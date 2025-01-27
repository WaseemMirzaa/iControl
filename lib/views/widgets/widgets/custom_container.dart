import 'package:flutter/material.dart';
import 'package:app_name/views/core/core/utils/constants/app_assets.dart';
import 'package:sizer/sizer.dart';

class CustomShapeContainer extends StatelessWidget {
  CustomShapeContainer({super.key, this.height});
  double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.header,
      height: height ?? 210,
      width: 100.w,
      fit: BoxFit.fill,
    );
  }
}
