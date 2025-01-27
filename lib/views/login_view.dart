import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_name/controllers/auth_controller.dart';
import 'package:app_name/views/core/core/utils/routes/app_routes.dart';
import 'package:app_name/views/signup_view.dart';
import 'package:app_name/views/widgets/widgets/auth_components/authComponents.dart';
import 'package:app_name/views/widgets/widgets/auth_textfield.dart';
import 'package:app_name/views/widgets/widgets/common_space.dart';
import 'package:app_name/views/widgets/widgets/reuse_button.dart';
import 'package:sizer/sizer.dart';
import 'package:app_name/views/core/core/utils/app_colors/app_colors.dart';
import 'package:app_name/views/core/core/utils/constants/app_assets.dart';
import 'package:app_name/views/core/core/utils/constants/temp_language.dart';
import 'package:app_name/views/core/core/utils/constants/text_styles.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    //get auth controller here
    final AuthController authController = Get.find<AuthController>();
    return PopScope(
      canPop: false,
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
                    Text(TempLanguage.txtLogin,
                        style: poppinsMedium(fontSize: 18)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupView(),
                          ),
                        );
                      },
                      child: Text(
                        'New User? Sign Up',
                        style: poppinsRegular(
                            fontSize: 13, color: AppColors.hintText),
                      ),
                    ),
                  ],
                ),
                const SpacerBoxVertical(height: 20),
                TextFieldWidget(
                  text: TempLanguage.lblEmailId,
                  path: AppAssets.emailIcon,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: authController.emailFocusNode,
                  onEditComplete: () => focusChange(
                      context,
                      authController.emailFocusNode,
                      authController.passwordFocusNode),
                  textController: authController.emailController,
                ),
                const SpacerBoxVertical(height: 20),
                TextFieldWidget(
                  text: TempLanguage.lblPassword,
                  path: AppAssets.unlockImg,
                  onChangepath: AppAssets.lockImg,
                  keyboardType: TextInputType.visiblePassword,
                  focusNode: authController.passwordFocusNode,
                  isPassword: true,
                  onEditComplete: () => unFocusChange(context),
                  textController: authController.passwordController,
                ),
                const SpacerBoxVertical(height: 20),
                CustomButton(
                  text: 'Login',
                  onPressed: () async {
                    await authController.login(
                        authController.emailController.text,
                        authController.passwordController.text);
                   
                  },
                  isLoading: authController.isLoading,
                  gradientColors: const [Colors.orange, Colors.red],
                  height: 60.0,
                  borderRadius: 12.0,
                  fontSize: 18.0,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                ),
                const SpacerBoxVertical(height: 1.5),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.forgotPassword);
                  },
                  child: Text(
                    TempLanguage.txtForgotPassword,
                    style: poppinsMedium(
                        fontSize: 18.sp, color: AppColors.secondaryText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
