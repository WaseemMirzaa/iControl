import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:app_name/views/core/core/utils/app_colors/app_colors.dart';

import 'package:app_name/views/core/core/utils/constants/app_assets.dart';
import 'package:app_name/views/core/core/utils/constants/temp_language.dart';
import 'package:app_name/views/core/core/utils/constants/text_styles.dart';
import 'package:app_name/views/core/core/utils/mixins/validate_textfield.dart';
import 'package:app_name/views/widgets/widgets/auth_textfield.dart';

import 'package:app_name/views/widgets/widgets/common_space.dart';
import 'package:app_name/views/widgets/widgets/reuse_button.dart';

import '../controllers/auth_controller.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView>
    with ValidationMixin {
  FocusNode emailFocusNode = FocusNode();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  TempLanguage.lblSwipe,
                  style: altoysFont(fontSize: 35),
                  textAlign: TextAlign.center,
                ),
              ),
              const SpacerBoxVertical(height: 20),
              Text(
                TempLanguage.txtEnterEmailToResetPassword,
                style: poppinsRegular(fontSize: 14, color: AppColors.hintText),
                textAlign: TextAlign.left,
              ),
              const SpacerBoxVertical(height: 30),
              TextFieldWidget(
                text: TempLanguage.lblEmailId,
                path: AppAssets.emailIcon,
                textController: authController.resetEmailController,
                keyboardType: TextInputType.emailAddress,
                focusNode: emailFocusNode,
                onEditComplete: () => FocusScope.of(context).unfocus(),
              ),
              const SpacerBoxVertical(height: 20),
              // ButtonWidget(
              //   onSwipe: () async {
              //     // No backend logic; simply reset the email text field for UI testing
              //     await authController.resetPassword(resetEmailController.text);
              //     resetEmailController.clear();
              //   },
              //   text: TempLanguage.btnLblResetPassword,
              // ),
              CustomButton(
                text: TempLanguage.btnLblResetPassword,
                onPressed: () async {
                  await authController
                      .resetPassword(authController.resetEmailController.text);
                },
                isLoading: authController.isLoading,
                gradientColors: [Colors.orange, Colors.red],
                height: 60.0,
                borderRadius: 12.0,
                fontSize: 18.0,
                padding: EdgeInsets.symmetric(horizontal: 4.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
