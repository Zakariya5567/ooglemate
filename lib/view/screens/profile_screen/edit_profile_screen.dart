import 'dart:convert';
import 'dart:io';

import 'package:caroogle/providers/profile_provider.dart';
import 'package:caroogle/utils/string.dart';
import 'package:caroogle/view/screens/profile_screen/components/edit_profile_list.dart';
import 'package:caroogle/view/widgets/custom_app_bar.dart';
import 'package:caroogle/view/widgets/custom_icon_button.dart';
import 'package:caroogle/view/widgets/custom_sizedbox.dart';
import 'package:caroogle/view/widgets/shimmer/shimmer_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../helper/date_format.dart';
import '../../../helper/routes_helper.dart';
import '../../../utils/api_url.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimension.dart';
import '../../../utils/images.dart';
import '../../../utils/style.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // To pick image from device
  File? image;
  final picker = ImagePicker();

  // show bottom sheet
  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          didChangeDependencies();
          return SafeArea(
              child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CustomIconButton(
                      icon: Images.iconCross,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      height: displayWidth(context, 0.045),
                      width: displayWidth(context, 0.045),
                      color: primaryBlack),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () {
                  imageFromGallery();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  imageFromCamera();
                  Navigator.pop(context);
                },
              ),
            ],
          ));
        });
  }

  // pick image from camera
  Future imageFromCamera() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1000,
        maxWidth: 1000,
        imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // pick image from gallery
  Future imageFromGallery() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1000,
        maxWidth: 1000,
        imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

// select date
  selectDate(
    BuildContext context,
  ) async {
    DateTime? newSelectedDate;

    newSelectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    print("Date ===============>>>>>>>>>>>  $newSelectedDate ");
    //     .then((value) {
    final String date = dateOfBirthFormatDash(newSelectedDate!);

    print("Date : ==============.>>>>>>>>> $date");
    Future.delayed(Duration.zero, () {
      Provider.of<ProfileProvider>(context, listen: false).setDobText(date);
    });

    // });
  }

  @override
  void initState() {
    super.initState();
    callingApi();
  }

  callingApi() {
    Future.delayed(Duration.zero, () {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.setLoading(true);
      provider.getProfile(context, RouterHelper.editProfileScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: greyStatusStatusBar(),
      child: SafeArea(
        bottom: Platform.isAndroid ? true : false,
        top: Platform.isAndroid ? true : false,
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: customAppBar(
            context: context,
            color: cardGreyColor,
            title: editProfile,
            page: 'profile_edit',
            icon1: const SizedBox(),
            icon2: const SizedBox(),
            icon3: const SizedBox(),
            icon4: InkWell(
              onTap: () async {
                if (image != null) {
                  provider.setImage(image!);
                }
                await provider
                    .updateProfile(context, RouterHelper.editProfileScreen)
                    .then((value) {
                  provider.getProfile(context, RouterHelper.editProfileScreen);
                  image = null;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  profileDone,
                  style: textStyle(
                      fontSize: 16, color: lightBlack, fontFamily: latoRegular),
                ),
              ),
            ),
          ),
          backgroundColor: primaryWhite,
          body:
              Consumer<ProfileProvider>(builder: (context, controller, child) {
            return controller.isLoading == true ||
                    controller.getProfileModel.data == null
                ? const ShimmerProfile()
                : SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: SizedBox(
                      height: displayHeight(context, 1),
                      width: displayWidth(context, 1),
                      child: Stack(
                        children: [
                          Container(
                            width: displayWidth(context, 1),
                            height: displayHeight(context, 0.25),
                            decoration: const BoxDecoration(
                                color: cardGreyColor,
                                border: Border(
                                    bottom: BorderSide(color: veryLightGrey))),
                          ),

                          //  white card
                          Positioned(
                            left: 20,
                            right: 20,
                            top: displayHeight(context, 0.17),
                            child: Container(
                              height: displayHeight(context, 0.55),
                              width: displayWidth(context, 1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primaryWhite,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: veryLightGrey,
                                      spreadRadius: 3.0,
                                      blurRadius: 5.0,
                                      offset: Offset(0, 4),
                                    )
                                  ],
                                  border: const Border(
                                      bottom:
                                          BorderSide(color: veryLightGrey))),
                            ),
                          ),

                          //text data
                          Positioned(
                              left: displayWidth(context, 0.09),
                              top: displayHeight(context, 0.30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  EditProfileList(
                                    title: profileUserName,
                                    controller: controller.userNameController,
                                    text: "Enter your Name",
                                    isDob: false,
                                  ),
                                  HeightSizedBox(context, 0.02),
                                  EditProfileList(
                                    title: profileEmail,
                                    controller: controller.emailController,
                                    text: "Enter your phone number",
                                    isDob: false,
                                  ),
                                  HeightSizedBox(context, 0.02),
                                  EditProfileList(
                                    title: profilePhone,
                                    controller: controller.phoneController,
                                    text: "Enter your phone number",
                                    isDob: false,
                                  ),
                                  HeightSizedBox(context, 0.02),
                                  EditProfileList(
                                    title: profileGender,
                                    controller: controller.genderController,
                                    text: "Enter your gender",
                                    isDob: false,
                                  ),
                                  HeightSizedBox(context, 0.02),
                                  InkWell(
                                    onTap: () {
                                      selectDate(context);
                                    },
                                    child: EditProfileList(
                                      title: profileDob,
                                      controller: TextEditingController(),
                                      text: "DD/MM/YY",
                                      isDob: true,
                                    ),
                                  ),
                                ],
                              )),

                          // image
                          Positioned(
                            left: displayWidth(context, 0.32),
                            top: displayHeight(context, 0.11),
                            child: image != null
                                ? CircleAvatar(
                                    backgroundColor: primaryGrey,
                                    radius: displayWidth(context, 0.17),
                                    backgroundImage: FileImage(
                                      image!,
                                    ),
                                    child: Stack(children: [
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: InkWell(
                                          onTap: () {
                                            showPicker(context);
                                          },
                                          child: CircleAvatar(
                                            radius:
                                                displayWidth(context, 0.055),
                                            backgroundColor: primaryBlue,
                                            child: Image.asset(
                                              Images.iconCamera,
                                              height:
                                                  displayWidth(context, 0.045),
                                              width:
                                                  displayWidth(context, 0.045),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  )
                                : controller.getProfileModel.data!.photo != null
                                    ? CircleAvatar(
                                        backgroundColor: primaryGrey,
                                        radius: displayWidth(context, 0.17),
                                        backgroundImage: NetworkImage(
                                            "${ApiUrl.baseUrl}${controller.getProfileModel.data!.photo!}"),
                                        child: Stack(children: [
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: InkWell(
                                              onTap: () {
                                                showPicker(context);
                                              },
                                              child: CircleAvatar(
                                                radius: displayWidth(
                                                    context, 0.055),
                                                backgroundColor: primaryBlue,
                                                child: Image.asset(
                                                  Images.iconCamera,
                                                  height: displayWidth(
                                                      context, 0.045),
                                                  width: displayWidth(
                                                      context, 0.045),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      )
                                    : CircleAvatar(
                                        radius: displayWidth(context, 0.17),
                                        backgroundColor: primaryGrey,
                                        child: Stack(children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.person,
                                              color: primaryWhite,
                                              size: displayWidth(context, 0.15),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: InkWell(
                                              onTap: () {
                                                showPicker(context);
                                              },
                                              child: CircleAvatar(
                                                radius: displayWidth(
                                                    context, 0.055),
                                                backgroundColor: primaryBlue,
                                                child: Image.asset(
                                                  Images.iconCamera,
                                                  height: displayWidth(
                                                      context, 0.045),
                                                  width: displayWidth(
                                                      context, 0.045),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                          )
                        ],
                      ),
                    ));
          }),
        ),
      ),
    );
  }
}
