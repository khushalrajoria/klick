import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../edit_profile_screen/edit_profile_screen.dart';
import '../image_gallery_screen/image_gallery_screen.dart';
import '../open_page_screen/open_page_screen.dart';
import 'models/my_profile_model.dart';
import 'provider/my_profile_provider.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  MyProfileScreenState createState() => MyProfileScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyProfileProvider(),
      child: const MyProfileScreen(),
    );
  }
}

class MyProfileScreenState extends State<MyProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<MyProfileProvider>(context, listen: false).fetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Consumer<MyProfileProvider>(
          builder: (context, myProfileProvider, child) {
            if (myProfileProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (myProfileProvider.errorMessage != null) {
              return Center(child: Text(myProfileProvider.errorMessage!));
            }

            final profile = myProfileProvider.myProfileModelObj;
            if (profile == null) {
              return const Center(child: Text('No profile data'));
            }

            return _buildProfileContent(profile);
          },
        ),
      ),
    );
  }
  Widget _buildProfileContent(MyProfileModel profile) {
    return SizedBox(
      width: SizeUtils.width,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 14.v),
        child: Container(
          margin: EdgeInsets.only(
            left: 43.h,
            right: 54.h,
            bottom: 5.v,
          ),
          decoration: AppDecoration.fillGray.copyWith(color: Color.fromRGBO(250, 249, 246, 1)),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 110.v,
                  width: 111.h,
                  margin: EdgeInsets.only(right: 78.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 110.adaptSize,
                          width: 110.adaptSize,
                          decoration: BoxDecoration(
                            color: appTheme.blueGray100,
                            borderRadius: BorderRadius.circular(
                              55.h,
                            ),
                            border: Border.all(
                              color: appTheme.deepcyanA200,
                              width: 4.h,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ImageGalleryScreen()));
                        },
                        // child: CustomImageView(
                        //   base64Decode(profile.profilePic),
                        //   height: 110.adaptSize,
                        //   width: 110.adaptSize,
                        //   radius: BorderRadius.circular(
                        //     55.h,
                        //   ),
                        //   alignment: Alignment.center,
                        // ),
                        child: 
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(55)
                          ),
                         alignment: Alignment.center,
                          child: Image.memory(
                            base64Decode(profile.profilePic),
                            height: 110.adaptSize,
                            width: 110.adaptSize,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.v),
              Text(
                profile.name,
                style: TextStyle(
                    color: appTheme.cyan300,
                    fontFamily: 'Inria Sans',
                    fontSize: 21,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                profile.email,
                style: theme.textTheme.titleSmall,
              ),
              SizedBox(height: 37.v),
              Padding(
                padding: EdgeInsets.only(left: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Name",
                      style: theme.textTheme.titleLarge,
                    ),
                    Text(
                      profile.name,
                      style: theme.textTheme.titleSmall,
                    )
                  ],
                ),
              ),
              SizedBox(height: 7.v),
              Padding(
                padding: EdgeInsets.only(left: 13.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6.v),
                      child: Text(
                        "Gender",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.v),
                      child: Text(
                       " ${profile.maingender}-${profile.gender}",
                        style: theme.textTheme.titleSmall,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 12.v),
              Padding(
                padding: EdgeInsets.only(
                  left: 13.h,
                  right: 3.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date of Birth",
                      style: theme.textTheme.titleLarge,
                    ),
                    Text(
                      profile.dob.substring(0,10),
                      style: theme.textTheme.titleSmall,
                    )
                  ],
                ),
              ),
              SizedBox(height: 34.v),
              Padding(
                padding: EdgeInsets.only(
                  left: 13.h,
                  right: 4.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 1.v),
                      child: Text(
                        "Country",
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Text(
                      profile.country,
                      style: theme.textTheme.titleSmall,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.v),
              Padding(
                padding: EdgeInsets.only(
                  left: 13.h,
                  right: 3.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Preference",
                      style: theme.textTheme.titleLarge,
                    ),
                    Text(
                      "${profile.preferredgender}" "${profile.prefgender}",
                      style: theme.textTheme.titleSmall,
                    )
                  ],
                ),
              ),
              SizedBox(height: 41.v),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: profile.instaID!='' ? true: false,
                        child: Container(
                          height: 45.v,
                          width: 44.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                ImageConstant.imgImage10,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 14.v,
                          bottom: 11.v,
                        ),
                        child: Text(
                        " @${profile.instaID}",
                          style: theme.textTheme.titleSmall,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15.v),
                  Padding(
                    padding: EdgeInsets.only(left: 7.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: profile.snapID!='' ? true: false,
                          child: Container(
                            height: 36.v,
                            width: 29.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                14.h,
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  ImageConstant.imgImage9,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                           visible: profile.snapID!='' ? true: false,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 9.v,
                              bottom: 7.v,
                            ),
                            child: Text(
                             "@${profile.snapID}",
                              style: theme.textTheme.titleSmall,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
              SizedBox(height: 43.v),
              InkWell(
                onTap: () async {
                  bool confirmLogout = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirm Logout'),
                        content: const Text(
                            'Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(true),
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmLogout) {
                    var sharedPref = await SharedPreferences.getInstance();
                    await sharedPref.setBool(OpenPageScreenState.keyLogin, false);
                    await sharedPref.setInt(OpenPageScreenState.uId, 0);
                    NavigatorService.popAndPushNamed(AppRoutes.loginPageScreen);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  width: 161.h,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 5,),
                          Text(
                            "LogOut",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6.v),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Can't continue? ",
                      style: theme.textTheme.titleSmall,
                    ),
                    TextSpan(
                      text: " delete account",
                      style: CustomTextStyles.titleMediumcyan200_1,
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 61.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowDownOnprimary,
        margin: EdgeInsets.only(
          left: 35.h,
          top: 18.v,
          bottom: 17.v,
        ),
      ),
      title: AppbarSubtitle(
        text: "Profile",
        margin: EdgeInsets.only(left: 12.h),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditProfileScreen()));
          },
        ),
      ],
    );
  }
}
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../core/utils/image_constant.dart';
// import '../edit_profile_screen/edit_profile_screen.dart';
// import '../image_gallery_screen/image_gallery_screen.dart';
// import 'provider/my_profile_provider.dart';
// import 'models/my_profile_model.dart';

// class MyProfileScreen extends StatefulWidget {
//   const MyProfileScreen({Key? key}) : super(key: key);

//   @override
//   MyProfileScreenState createState() => MyProfileScreenState();

//   static Widget builder(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MyProfileProvider(),
//       child: const MyProfileScreen(),
//     );
//   }
// }

// class MyProfileScreenState extends State<MyProfileScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() =>
//         Provider.of<MyProfileProvider>(context, listen: false).fetchProfile());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: _buildAppBar(context),
//         body: Consumer<MyProfileProvider>(
//           builder: (context, myProfileProvider, child) {
//             if (myProfileProvider.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (myProfileProvider.errorMessage != null) {
//               return Center(child: Text(myProfileProvider.errorMessage!));
//             }

//             final profile = myProfileProvider.myProfileModelObj;
//             if (profile == null) {
//               return const Center(child: Text('No profile data'));
//             }

//             return _buildProfileContent(profile);
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileContent(MyProfileModel profile) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       child: SingleChildScrollView(
//         padding: EdgeInsets.all(14),
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Container(
//                   height: 110,
//                   width: 110,
//                   margin: EdgeInsets.all(8),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Container(
//                         height: 110,
//                         width: 110,
//                         decoration: BoxDecoration(
//                           color: Colors.blueGrey[100],
//                           borderRadius: BorderRadius.circular(55),
//                           border: Border.all(
//                             color: Colors.cyan[700]!,
//                             width: 4,
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => ImageGalleryScreen()));
//                         },
//                         child: Image.memory(
//                           base64Decode(profile.profilePic),
//                           height: 110,
//                           width: 110,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Icon(Icons.error);
//                           },
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 profile.name,
//                 style: TextStyle(
//                     color: Color.fromARGB(255, 31, 243, 197),
//                     fontFamily: 'Inria Sans',
//                     fontSize: 21,
//                     fontWeight: FontWeight.w600),
//               ),
//               Text(
//                 profile.email,
//                 style: Theme.of(context).textTheme.labelLarge,
//               ),
//               SizedBox(height: 37),
//               _buildProfileRow("Name", profile.name),
//               _buildProfileRow("Gender", "${profile.maingender}-${profile.gender}"),
//               _buildProfileRow("Date of Birth", profile.dob.substring(0, 10)),
//               _buildProfileRow("Country", profile.country),
//               _buildProfileRow("Preference", "${profile.preferredgender} ${profile.prefgender}"),
//               SizedBox(height: 20),
//               Visibility(
//                 visible: profile.instaID.isNotEmpty,
//                 child: _buildSocialRow(ImageConstant.imgImage10, profile.instaID),
//               ),
//               Visibility(
//                 visible: profile.snapID.isNotEmpty,
//                 child: _buildSocialRow(ImageConstant.imgImage9, profile.snapID),
//               ),
//               SizedBox(height: 43),
//               _buildLogoutButton(),
//               SizedBox(height: 6),
//               RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: "Can't continue?",
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     TextSpan(
//                       text: " delete account",
//                       style: TextStyle(color: Colors.cyan[200]),
//                     ),
//                   ],
//                 ),
//                 textAlign: TextAlign.left,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: Theme.of(context).textTheme.titleSmall,
//           ),
//           Text(
//             value,
//             style: Theme.of(context).textTheme.titleSmall,
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildSocialRow(String imagePath, String handle) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Image.asset(
//             imagePath,
//             height: 45,
//             width: 45,
//             fit: BoxFit.cover,
//           ),
//           Text(
//             "@$handle",
//             style: Theme.of(context).textTheme.titleSmall,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLogoutButton() {
//     return InkWell(
//       onTap: () {
//         // Add your logout logic here
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 16),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.cyan[200],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.logout, color: Colors.white),
//             SizedBox(width: 8),
//             Text(
//               "Logout",
//               style: TextStyle(color: Colors.white),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.grey[200],
//       elevation: 0,
//       leading: InkWell(
//         onTap: () {
//           Navigator.pop(context);
//         },
//         child: Icon(
//           Icons.arrow_back_ios_new_rounded,
//           color: Colors.cyan[200],
//         ),
//       ),
//       title: Text(
//         "My Profile",
//         style: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontFamily: 'Urbanist',
//             fontWeight: FontWeight.w600),
//       ),
//       centerTitle: true,
//       actions: [
//         Padding(
//           padding: EdgeInsets.only(right: 16),
//           child: InkWell(
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => EditProfileScreen()));
//             },
//             child: Icon(
//               Icons.edit,
//               color: Colors.cyan[200],
//               size: 25,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
