import 'package:flutter/material.dart';
import 'package:open_signup_login_page1_signup/presentation/page_3_sign_up_screen/page_3_sign_up_screen.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../page_3_sign_up_screen/provider/page_3_sign_up_provider.dart';
import 'models/page_2_sign_up_model.dart';
import 'provider/page_2_sign_up_provider.dart';

class Page2SignUpScreen extends StatefulWidget {
  // const Page2SignUpScreen({Key? key})
  //     : super(
  //         key: key,
  //       );
  final String email;
  final String password;
  final String fullName;
  final String dateOfBirth;
  final String country;
  final String gender;

  Page2SignUpScreen({
    required this.email,
    required this.password,
    required this.fullName,
    required this.dateOfBirth,
    required this.country,
    required this.gender,
  });
  @override
  Page2SignUpScreenState createState() => Page2SignUpScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Page2SignUpProvider(),
      child: Page2SignUpScreen(
        email: '',
        password: '',
        fullName: '',
        dateOfBirth: '',
        country: '',
        gender: '',
      ),
    );
  }
}

class Page2SignUpScreenState extends State<Page2SignUpScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 31.h,
            vertical: 11.v,
          ),
          child: Column(
            children: [
              SizedBox(height: 71.v),
              Text(
                "lbl_socials".tr,
                style: theme.textTheme.displayLarge,
              ),
              SizedBox(height: 37.v),
              Selector<Page2SignUpProvider, TextEditingController?>(
                selector: (context, provider) =>
                    provider.snapchatidoneController,
                builder: (context, snapchatidoneController, child) {
                  return CustomTextFormField(
                    controller: snapchatidoneController,
                    hintText: "msg_enter_your_snap_chat".tr,
                  );
                },
              ),
              SizedBox(height: 47.v),
              Selector<Page2SignUpProvider, TextEditingController?>(
                selector: (context, provider) =>
                    provider.instagramidoneController,
                builder: (context, instagramidoneController, child) {
                  return CustomTextFormField(
                    controller: instagramidoneController,
                    hintText: "msg_enter_your_instagram".tr,
                    textInputAction: TextInputAction.done,
                  );
                },
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "lbl".tr,
                        style: CustomTextStyles.bodySmallOnPrimaryContainer,
                      ),
                      TextSpan(
                        text: "msg_you_must_enter_one".tr,
                        style: theme.textTheme.bodySmall,
                      )
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: _buildNextButton(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildNextButton(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl_next".tr,
      margin: EdgeInsets.only(
        left: 31.h,
        right: 32.h,
        bottom: 52.v,
      ),
      onPressed: () {
        onTapNextButton(context);
      },
    );
  }

  /// Navigates to the page3SignUpScreen when the action is triggered.
  onTapNextButton(BuildContext context) {
    final provider = Provider.of<Page2SignUpProvider>(context, listen: false);
    final instaId = provider.instagramidoneController;
    final snapId = provider.snapchatidoneController;
    if(instaId.text.isNotEmpty||snapId.text.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
         builder: (context) => ChangeNotifierProvider<Page3SignUpProvider>(
           create: (context) => Page3SignUpProvider(),
           child: Page3SignUpScreen(
            email: widget.email,
            password: widget.password,
            fullName: widget.fullName,
            dateOfBirth: widget.dateOfBirth,
            country: widget.country,
            gender: widget.gender,
            instaId: instaId.text,
            snapId: snapId.text
           ),
          ),
        ),
      );
    }
  }
}
