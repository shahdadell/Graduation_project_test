// lib/Profile_screen/UI/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Profile_screen/bloc/profile_bloc.dart';
import 'package:graduation_project/Profile_screen/bloc/profile_event.dart';
import 'package:graduation_project/Profile_screen/bloc/profile_state.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/Profile_screen/UI/profile_widgets.dart';
import '../data/repo/profile_repo.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/edit-profile-screen';
  final String userId;
  final dynamic profile;

  const EditProfileScreen({super.key, required this.userId, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile?.usersName ?? '');
    _emailController = TextEditingController(text: widget.profile?.usersEmail ?? '');
    _phoneController = TextEditingController(text: widget.profile?.usersPhone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // دالة للتحقق من الحقول قبل الإرسال
  bool _validateFields() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name cannot be empty")),
      );
      return false;
    }
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email cannot be empty")),
      );
      return false;
    }
    if (!_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email")),
      );
      return false;
    }
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone cannot be empty")),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme; // متغير لتقليل التكرار

    return BlocProvider(
      create: (context) => ProfileBloc(ProfileRepo()),
      child: Scaffold(
        appBar: _buildAppBar(context, textTheme),
        body: Container(
          color: MyTheme.whiteColor,
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile updated successfully")),
                );
                Navigator.pop(context); // العودة لصفحة البروفايل بعد التعديل
              } else if (state is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is ProfileLoading) {
                return Center(
                  child: CircularProgressIndicator(color: MyTheme.orangeColor),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildProfileImage(widget.profile?.usersImage, true),
                      SizedBox(height: 20.h),
                      _buildProfileCard(context),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: () {
                          if (_validateFields()) { // التحقق من الحقول قبل الإرسال
                            context.read<ProfileBloc>().add(
                              UpdateProfileEvent(
                                widget.userId,
                                _nameController.text,
                                _emailController.text,
                                _phoneController.text,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.orangeColor,
                          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          "Save Changes",
                          style: textTheme.displayMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Icon(Icons.arrow_back_ios, color: MyTheme.whiteColor, size: 24.w),
        ),
      ),
      title: Text(
        "Edit Profile",
        style: textTheme.displayLarge,
      ),
      centerTitle: true,
      backgroundColor: MyTheme.orangeColor,
      // elevation: 4,
      // shadowColor: Colors.black.withOpacity(0.3),
      // flexibleSpace: Container(
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       colors: [MyTheme.orangeColor, Colors.orange[400]!],
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: MyTheme.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildEditableField(context, "Name", _nameController, Icons.person, isEditing: true),
          buildEditableField(context, "Email", _emailController, Icons.email, isEditing: true),
          buildEditableField(context, "Phone", _phoneController, Icons.phone, isEditing: true),
        ],
      ),
    );
  }
}