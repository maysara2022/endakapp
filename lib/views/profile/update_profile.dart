import 'dart:io';
import 'package:endakapp/controllers/user/user_controller.dart';
import 'package:endakapp/core/constants/app_colors.dart';
import 'package:endakapp/core/constants/app_process.dart';
import 'package:endakapp/core/constants/app_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../register/widgets/text_field.dart';

class UpdateProfile extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String? bio;
  final String? avatar;

  const UpdateProfile({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    this.bio,
    this.avatar,
  });

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  final UserProfileController _userProfileController = Get.put(UserProfileController());
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print(widget.avatar);
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _bioController = TextEditingController(text: widget.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      AppProcess.warring('خطأ', 'فشل في اختيار الصورة');
    }
  }

  Future<void> _handleUpdate() async {
    bool checkForms = checkFields();
    if (!checkForms) return;

    setState(() => _isLoading = true);

    try {
      await _userProfileController.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
        avatar: _selectedImage,
      );
      Get.back();
      AppProcess.success('نجاح', 'تم تحديث الملف الشخصي بنجاح');
    } catch (e) {
      AppProcess.warring('خطأ', 'فشل في تحديث الملف الشخصي');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool checkFields() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      AppProcess.warring('', 'قم بالتأكد من البيانات المدخلة');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (widget.avatar != null && widget.avatar!.isNotEmpty
                          ? NetworkImage(
                          widget.avatar!.startsWith('http')
                              ? widget.avatar!
                              : 'https://endak.net/storage/${widget.avatar!}'
                      ) as ImageProvider
                          : null),
                      child: (_selectedImage == null &&
                          (widget.avatar == null || widget.avatar!.isEmpty))
                          ? Icon(
                        Iconsax.user,
                        size: 50,
                        color: AppColors.primaryColor,
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Iconsax.camera,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // حقول الإدخال
              CustomTextField(
                label: 'الاسم كامل',
                keyType: TextInputType.name,
                controller: _nameController,
                icon: Iconsax.user,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: 'البريد الإلكتروني',
                keyType: TextInputType.emailAddress,
                controller: _emailController,
                icon: Icons.email,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: 'رقم الهاتف',
                keyType: TextInputType.phone,
                controller: _phoneController,
                icon: Icons.phone,
              ),

              const SizedBox(height: 16),
              CustomTextField(
                label: 'نبذة',
                keyType: TextInputType.text,
                controller: _bioController,
                icon: Icons.info_outline,
                maxLines: 5,
                minLines: 2,
              ),
              const SizedBox(height: 30),


              // زر التحديث
              SizedBox(
                width: AppSize.screenWidth,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleUpdate,
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.all(16),
                    ),
                    backgroundColor: WidgetStateProperty.all(
                      AppColors.primaryColor,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'حفظ التعديلات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}