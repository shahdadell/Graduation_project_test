import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Profile_screen/bloc/profile_bloc.dart';
import 'package:graduation_project/Profile_screen/bloc/profile_event.dart';
import 'package:graduation_project/Profile_screen/bloc/profile_state.dart';
import 'package:graduation_project/Profile_screen/data/auth_utils.dart';
import 'package:graduation_project/Profile_screen/data/repo/profile_repo.dart';
import 'package:graduation_project/Theme/theme.dart';
import 'package:graduation_project/Profile_screen/UI/edit_profile_screen.dart';
import 'package:graduation_project/Profile_screen/UI/profile_widgets.dart';
import 'package:graduation_project/local_data/shared_preference.dart';
import 'package:graduation_project/Main_Screen/main_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile-screen';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<int?>(
      future: AuthUtils.getUserIdDirectly(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: MyTheme.orangeColor),
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: _buildAppBar(context, textTheme),
            body: Center(
              child: Text(
                "Error loading user ID or not logged in",
                style: textTheme.titleMedium?.copyWith(color: MyTheme.grayColor2),
              ),
            ),
          );
        } else {
          final userId = snapshot.data!.toString();
          return BlocProvider(
            create: (context) => ProfileBloc(ProfileRepo())..add(FetchProfileEvent(userId)),
            child: Scaffold(
              appBar: _buildAppBar(context, textTheme),
              body: Container(
                color: MyTheme.whiteColor,
                child: BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileError) {
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
                    } else if (state is ProfileLoaded) {
                      final profile = state.profile.data;
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildProfileImage(profile?.usersImage, false),
                              SizedBox(height: 20.h),
                              _buildProfileCard(context, profile),
                              SizedBox(height: 20.h),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    EditProfileScreen.routeName,
                                    arguments: {
                                      'userId': userId,
                                      'profile': profile,
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyTheme.orangeColor,
                                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 8.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  elevation: 5,
                                ),
                                child: Text(
                                  "Edit Profile",
                                  style: textTheme.displayMedium,
                                ),
                              ),
                              SizedBox(height: 15.h),
                              ElevatedButton(
                                onPressed: () async {
                                  await AppLocalStorage.clearData();
                                  Navigator.pushReplacementNamed(
                                    context,
                                    MainScreen.routName,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyTheme.orangeColor, // لون مختلف للتسجيل الخروج
                                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 8.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  elevation: 5,
                                ),
                                child: Text(
                                  "Log Out",
                                  style: textTheme.displayMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is ProfileError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Error: ${state.message}",
                              style: textTheme.titleMedium?.copyWith(color: MyTheme.redColor),
                            ),
                            SizedBox(height: 20.h),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ProfileBloc>().add(FetchProfileEvent(userId));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyTheme.orangeColor,
                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                "Retry",
                                style: textTheme.displayMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ProfileBloc>().add(FetchProfileEvent(userId));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.orangeColor,
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          "Load Profile",
                          style: textTheme.displayMedium,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, TextTheme textTheme) {
    return AppBar(
       leading: null,
      // InkWell(
      //   onTap: () => Navigator.pop(context),
      //   child: Padding(
      //     padding: EdgeInsets.all(12.w),
      //     child: Icon(Icons.arrow_back_ios, color: MyTheme.whiteColor, size: 24.w),
      //   ),
      // ),
      title: Text(
        "My Profile",
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

  Widget _buildProfileCard(BuildContext context, dynamic profile) {
    final nameController = TextEditingController(text: profile?.usersName ?? '');
    final emailController = TextEditingController(text: profile?.usersEmail ?? '');
    final phoneController = TextEditingController(text: profile?.usersPhone ?? '');

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
          buildEditableField(context, "Name", nameController, Icons.person),
          buildEditableField(context, "Email", emailController, Icons.email),
          buildEditableField(context, "Phone", phoneController, Icons.phone),
        ],
      ),
    );
  }
}