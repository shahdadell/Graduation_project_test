import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/Profile_screen/bloc/profile_bloc.dart';
import 'package:graduation_project/Profile_screen/bloc/profile_event.dart';
import 'package:graduation_project/Profile_screen/bloc/profile_state.dart';
import 'package:graduation_project/Profile_screen/data/auth_utils.dart';
import 'package:graduation_project/Profile_screen/data/repo/profile_repo.dart';
import 'package:graduation_project/Theme/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            appBar: _buildAppBar(context),
            body: Center(
              child: Text(
                "Error loading user ID or not logged in",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: MyTheme.grayColor2),
              ),
            ),
          );
        } else {
          final userId = snapshot.data!.toString();
          return BlocProvider(
            create: (context) => ProfileBloc(ProfileRepo())..add(FetchProfileEvent(userId)),
            child: Scaffold(
              appBar: _buildAppBar(context),
              body: Container(
                color: MyTheme.whiteColor, // تتطابق مع scaffoldBackgroundColor
                child: BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileUpdated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Profile updated successfully")),
                      );
                      setState(() {
                        _isEditing = false;
                        _passwordController.clear();
                      });
                    } else if (state is ProfileError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                      setState(() => _isEditing = true);
                    }
                  },
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return Center(
                        child: CircularProgressIndicator(color: MyTheme.orangeColor),
                      );
                    } else if (state is ProfileLoaded || state is ProfileUpdated) {
                      final profile = (state is ProfileLoaded)
                          ? state.profile.data
                          : (state as ProfileUpdated).response.data;
                      _nameController.text = profile?.usersName ?? '';
                      _emailController.text = profile?.usersEmail ?? '';
                      _phoneController.text = profile?.usersPhone ?? '';

                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildProfileImage(profile?.usersImage),
                              SizedBox(height: 20.h),
                              _buildProfileCard(context, profile, userId),
                              SizedBox(height: 20.h),
                              ElevatedButton(
                                onPressed: () {
                                  if (_isEditing) {
                                    context.read<ProfileBloc>().add(
                                      UpdateProfileEvent(
                                        userId,
                                        _nameController.text,
                                        _emailController.text,
                                        _phoneController.text,
                                        password: _passwordController.text.isNotEmpty
                                            ? _passwordController.text
                                            : null,
                                      ),
                                    );
                                  } else {
                                    setState(() => _isEditing = true);
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
                                  _isEditing ? "Save Changes" : "Edit Profile",
                                  style: Theme.of(context).textTheme.displayMedium,
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
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: MyTheme.redColor),
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
                                style: Theme.of(context).textTheme.displayMedium,
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
                          style: Theme.of(context).textTheme.displayMedium,
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Icon(Icons.arrow_back_ios, color: MyTheme.whiteColor, size: 24.w),
        ),
      ),
      title: Text(
        "My Profile",
        style: Theme.of(context).textTheme.displayLarge,
      ),
      centerTitle: true,
      backgroundColor: MyTheme.orangeColor,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [MyTheme.orangeColor, Colors.orange[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(String? imageUrl) {
    return Stack(
      children: [
        Container(
          width: 130.w,
          height: 130.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: MyTheme.orangeColor2, width: 3.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.r,
                spreadRadius: 2.r,
              ),
            ],
          ),
          child: ClipOval(
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.person,
                size: 60.w,
                color: MyTheme.grayColor,
              ),
            )
                : Icon(
              Icons.person,
              size: 60.w,
              color: MyTheme.grayColor,
            ),
          ),
        ),
        if (_isEditing)
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: MyTheme.orangeColor,
              child: Icon(Icons.camera_alt, color: MyTheme.whiteColor, size: 20.w),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context, dynamic profile, String userId) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: MyTheme.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableField("Name", _nameController, Icons.person),
          _buildEditableField("Email", _emailController, Icons.email),
          _buildEditableField("Phone", _phoneController, Icons.phone),
          if (_isEditing) _buildEditableField("Password", _passwordController, Icons.lock),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Icon(icon, color: MyTheme.orangeColor2, size: 20.w),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: MyTheme.grayColor2),
                ),
                SizedBox(height: 5.h),
                _isEditing
                    ? TextField(
                  controller: controller,
                  style: Theme.of(context).textTheme.titleMedium,
                  obscureText: label == "Password",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: MyTheme.grayColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: MyTheme.grayColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  ),
                )
                    : Text(
                  controller.text,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}