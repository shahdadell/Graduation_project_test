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
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: AuthUtils.getUserIdDirectly(),
      builder: (context, snapshot) {
        print('User ID from AuthUtils: ${snapshot.data}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: MyTheme.orangeColor),
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[100]!, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Text(
                  "Error loading user ID or not logged in",
                  style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                ),
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[100]!, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileUpdated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Profile updated successfully")),
                      );
                      setState(() => _isEditing = false);
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
                    } else if (state is ProfileLoaded || state is ProfileUpdated) {
                      final profile = (state is ProfileLoaded)
                          ? state.profile.data
                          : (state as ProfileUpdated).response.data;
                      _nameController.text = profile?.usersName ?? '';
                      _emailController.text = profile?.usersEmail ?? '';
                      _phoneController.text = profile?.usersPhone ?? '';

                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20.h),
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
                                      ),
                                    );
                                  } else {
                                    setState(() => _isEditing = true);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyTheme.orangeColor,
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Text(
                                  _isEditing ? "Save" : "Edit Profile",
                                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is ProfileError) {
                      return Center(
                        child: Text(
                          "Error: ${state.message}",
                          style: TextStyle(fontSize: 16.sp, color: Colors.redAccent),
                        ),
                      );
                    }
                    return Center(
                      child: Text(
                        "Press to load profile",
                        style: TextStyle(fontSize: 16.sp, color: Colors.black87),
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
        "Profile",
        style: TextStyle(
          fontSize: 22.sp,
          color: MyTheme.whiteColor,
          fontWeight: FontWeight.bold,
        ),
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
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[200]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8.r,
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
            color: Colors.grey[400],
          ),
        )
            : Icon(
          Icons.person,
          size: 60.w,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, dynamic profile, String userId) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditableField("Name", _nameController),
          _buildEditableField("Email", _emailController),
          _buildEditableField("Phone", _phoneController),
          _buildProfileItem("User ID", profile?.usersId ?? 'N/A'),
          _buildProfileItem("Approved", profile?.usersApprove ?? 'N/A'),
          _buildProfileItem("Created", profile?.usersCreate ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _isEditing
                ? TextField(
              controller: controller,
              style: TextStyle(fontSize: 16.sp),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              ),
            )
                : Text(
              controller.text,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
