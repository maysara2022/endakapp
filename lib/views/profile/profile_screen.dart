import 'package:endakapp/controllers/auth/login/login_controller.dart';
import 'package:endakapp/controllers/user/user_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:endakapp/models/user/user_model.dart';
import 'package:endakapp/views/profile/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileScreen extends GetView<UserProfileController> {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserProfileController());

    return Scaffold(
      body: Obx(() {
        // حالة التحميل
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        // حالة الخطأ
        if (controller.errorMessage.value.isNotEmpty && controller.user.value == null) {
          return _buildErrorState();
        }

        // حالة عدم وجود بيانات
        if (controller.user.value == null) {
          return _buildEmptyState();
        }

        // عرض البيانات
        return _buildProfileContent();
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
          SizedBox(height: 16),
          Text(
            'جاري تحميل البيانات...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            SizedBox(height: 24),
            Text(
              'حدث خطأ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Obx(() => Text(
              'تعذر الاتصال بالخادم',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            )),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.fetchUserData(),
              icon: Icon(Icons.refresh),
              label: Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد بيانات',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    final user = controller.user.value!;

    return RefreshIndicator(
      onRefresh: controller.refreshUserData,
      color: AppColors.primaryColor,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: AppSize.screenHeight/3.5,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFF33616F),
                      Color(0xFF5E8B96),
                      Color(0xFFF3A446),

                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      _buildAvatar(user),
                      SizedBox(height: 12),
                      Text(
                        user.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      _buildUserTypeBadge(user),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user.bio != null && user.bio!.isNotEmpty) ...[
                    _buildBioSection(user),
                    SizedBox(height: 24),
                  ],
                  _buildContactCard(user),
                  SizedBox(height: 16),
                  _buildAccountDetailsCard(user),
                  SizedBox(height: 16),
                  _buildStatsCard(user),
                  SizedBox(height: 24),
                  _buildActionButtons(user),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(UserModel user) {
    return Hero(
      tag: 'user_avatar_${user.id}',
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          backgroundImage: user.avatar != null && user.avatar!.isNotEmpty
              ? NetworkImage(
            user.avatar!.startsWith('http')
                ? user.avatar!
                : 'https://endak.net/storage/${user.avatar!}',
          )
              : null,
          child: user.avatar == null || user.avatar!.isEmpty
              ? Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          )
              : null,
        ),
      ),
    );
  }

  Widget _buildUserTypeBadge(UserModel user) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            user.isAdmin ? Icons.admin_panel_settings : Icons.person,
            color: Colors.white,
            size: 16,
          ),
          SizedBox(width: 6),
          Text(
            user.isAdmin ? 'مسؤول' : controller.getUserTypeLabel(user.userType),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection(UserModel user) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                'نبذة عني',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            user.bio!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(UserModel user) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoTile(
            icon: Icons.email_outlined,
            title: 'البريد الإلكتروني',
            value: user.email,
            isVerified: user.emailVerifiedAt != null,
          ),
          Divider(height: 1),
          _buildInfoTile(
            icon: Icons.phone_outlined,
            title: 'رقم الهاتف',
            value: user.phone,
            isVerified: user.phoneVerifiedAt != null,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetailsCard(UserModel user) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفاصيل الحساب',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          if (user.createdAt != null)
            _buildDetailRow(
              'تاريخ التسجيل',
              controller.formatDate(user.createdAt!),
            ),
          if (user.termsAcceptedAt != null) ...[
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                SizedBox(width: 8),
                Text(
                  'تم قبول الشروط والأحكام',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildBioCard(UserModel user) {
    if (user.bio == null || user.bio!.trim().isEmpty) {
      return SizedBox(); // ما نعرضه إذا فاضي
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// العنوان
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: AppColors.primaryColor, // لون من هوية التطبيق
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'نبذة عني',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          /// نص البايو
          Text(
            user.bio!,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(UserModel user) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF33616F),
            Color(0xFF5E8B96),
            ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.verified_user,
            'موثق',
            user.emailVerifiedAt != null,
          ),
          Container(width: 1, height: 40, color: Colors.white30),
          _buildStatItem(
            Icons.admin_panel_settings,
            'المستوى',
            user.isAdmin ? 'مسؤول' : 'عضو',
          ),
          Container(width: 1, height: 40, color: Colors.white30),
          _buildStatItem(
            Icons.calendar_today,
            'نشط منذ',
            controller.getAccountAge(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, dynamic value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value is bool ? (value ? 'نعم' : 'لا') : value.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(UserModel user) {
    return Column(
      children: [
        _buildActionButton(
          icon: Icons.edit,
          label: 'تعديل الملف الشخصي',
          color: AppColors.primaryColor,
          onTap: ()async{
            await Get.to(() => UpdateProfile(name: user.name, phone: user.phone, email:user.email,bio: user.bio,avatar: user.avatar,));
            controller.refreshUserData();
            },
        ),
        SizedBox(height: 12),
        _buildActionButton(
          icon: Icons.logout,
          label: 'تسجيل الخروج',
          color: Colors.grey[700]!,
          onTap: controller.goToSettings,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    bool isVerified = false,
  }) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (isVerified)
                      Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 20,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}