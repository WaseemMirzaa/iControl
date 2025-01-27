import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_name/controllers/auth_controller.dart';
import 'package:app_name/views/core/core/utils/app_colors/app_colors.dart';
import 'package:app_name/views/core/core/utils/constants/app_assets.dart';
import 'package:app_name/views/core/core/utils/constants/temp_language.dart';
import 'package:app_name/views/core/core/utils/constants/text_styles.dart';
import 'package:app_name/views/widgets/widgets/auth_components/authComponents.dart';
import 'package:app_name/views/widgets/widgets/auth_textfield.dart';
import 'package:app_name/views/widgets/widgets/common_space.dart';
import 'package:app_name/views/widgets/widgets/reuse_button.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:sizer/sizer.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Text(
                    TempLanguage.lblSwipe,
                    style: altoysFont(fontSize: 35),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(TempLanguage.txtSignup,
                        style: poppinsMedium(fontSize: 18)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(TempLanguage.txtLogin,
                          style: poppinsRegular(
                              fontSize: 13, color: AppColors.hintText)),
                    ),
                  ],
                ),
                const SpacerBoxVertical(height: 10),
                const SpacerBoxVertical(height: 20),
                TextFieldWidget(
                  text: TempLanguage.txtUserName,
                  path: AppAssets.userImg,
                  keyboardType: TextInputType.name,
                  focusNode: authController.nameFocusNode,
                  onEditComplete: () => focusChange(
                      context,
                      authController.nameFocusNode,
                      authController.emailFocusNodeSignUp),
                  textController: authController.usernameController,
                ),
                const SpacerBoxVertical(height: 20),
                TextFieldWidget(
                  text: TempLanguage.lblEmailId,
                  path: AppAssets.emailIcon,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: authController.emailFocusNodeSignUp,
                  onEditComplete: () => focusChange(
                      context,
                      authController.emailFocusNodeSignUp,
                      authController.passwordFocusNodeSignUp),
                  textController: authController.emailControllerSignUp,
                ),
                const SpacerBoxVertical(height: 20),
                TextFieldWidget(
                  text: TempLanguage.lblPassword,
                  path: AppAssets.unlockImg,
                  isPassword: true,
                  onChangepath: AppAssets.lockImg,
                  keyboardType: TextInputType.visiblePassword,
                  focusNode: authController.passwordFocusNodeSignUp,
                  onEditComplete: () => focusChange(
                      context,
                      authController.passwordFocusNodeSignUp,
                      authController.phoneFocusNode),
                  textController: authController.passwordControllerSignUp,
                ),
                const SpacerBoxVertical(height: 20),
                TextFieldWidget(
                  text: TempLanguage.txtDummyPhoneNo,
                  path: 'assets/images/Pwd  Input.png',
                  keyboardType: TextInputType.phone,
                  focusNode: authController.phoneFocusNode,
                  onEditComplete: () => unFocusChange(context),
                  textController: authController.phoneController,
                ),
                const SpacerBoxVertical(height: 20),
                CustomButton(
                  text: "Signup",
                  onPressed: () async {
                    await authController.signUp(
                        authController.usernameController.text,
                        authController.emailControllerSignUp.text,
                        authController.passwordControllerSignUp.text);
                  },
                  isLoading: authController.isLoading,
                  gradientColors: const [Colors.orange, Colors.red],
                  height: 60.0,
                  borderRadius: 12.0,
                  fontSize: 18.0,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                ),
                const SpacerBoxVertical(height: 20),
                Obx(
                  () => Row(
                    children: [
                      const SpacerBoxHorizontal(width: 5),
                      RoundCheckBox(
                        size: 20.sp,
                        border: Border.all(
                            color: authController.confirm.value
                                ? Colors.green
                                : Colors.grey),
                        isChecked: authController.confirm.value,
                        checkedWidget: Icon(
                          Icons.check_rounded,
                          size: 15.sp,
                          color: AppColors.whiteColor,
                        ),
                        onTap: (tapped) => authController.confirm.value =
                            !authController.confirm.value,
                      ),
                      const SpacerBoxHorizontal(width: 5),
                      Text(
                        'Accept Terms & Condition',
                        style: poppinsRegular(
                            fontSize: 15, color: AppColors.secondaryText),
                      ),
                      const SizedBox(width: 10),
                      socialIconsComp(
                          icon: AppAssets.appleIcon,
                          bgColor: AppColors.blackColor),
                      socialIconsComp(
                          icon: AppAssets.googleImg,
                          bgColor: AppColors.blackColor),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget socialIconsComp({
    Function()? onTap,
    required String icon,
    required Color bgColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28.sp,
        width: 28.sp,
        decoration: BoxDecoration(
          color: bgColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.16),
              offset: const Offset(0, 3),
              blurRadius: 3,
            )
          ],
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: AppColors.whiteColor),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(icon),
          ),
        ),
      ),
    );
  }
}
