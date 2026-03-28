import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // ignore: unused_import
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../providers/user_provider.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Form controllers pre-filled from profile data
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().currentUser;
    _nameCtrl = TextEditingController(text: user?.username ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _addressCtrl = TextEditingController(text: user?.address ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // Save changes and pop back to ProfileScreen
  Future<void> _onSave() async {
    final userProvider = context.read<UserProvider>();
    final success = await userProvider.updateProfile(
      username: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      _showSnack('Profile updated');
      Navigator.pop(context);
    } else {
      _showSnack(userProvider.error ?? 'Failed to update profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UserProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      // App bar — no back arrow, automaticallyImplyLeading: false
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Edit Profile', style: AppTypography.headlineMedium),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Avatar section — initials circle with edit FAB and subtitle
                    _buildAvatarSection(),
                    const SizedBox(height: 24),
                    // Full Name input field
                    _buildLabeledField(
                      label: 'Full Name',
                      controller: _nameCtrl,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    // Email input field
                    _buildLabeledField(
                      label: 'Email',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    // Phone Number input field
                    _buildLabeledField(
                      label: 'Phone Number',
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    // Address multi-line field
                    _buildAddressField(),
                    const SizedBox(height: 20),
                    // Save Changes primary action button
                    _buildSaveButton(isLoading),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Avatar circle with initials, edit FAB, and subtitle caption
  Widget _buildAvatarSection() {
    return Center(
      child: Column(
        children: [
          // Relative-positioned avatar + edit FAB
          Stack(
            children: [
              // Initials avatar circle
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 2),
                ),
                child: Center(
                  child: Text(
                    'JD',
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              // Edit FAB — bottom-right with accent background
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showSnack('Coming soon'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.background, width: 4),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // "Change Profile Picture" subtitle
          Text(
            'Change Profile Picture',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Labeled text input — label above field
  Widget _buildLabeledField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        // Theme-driven TextField — no local style overrides
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: label),
        ),
      ],
    );
  }

  // Address multi-line field
  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Address',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        // Multi-line TextField for address
        TextField(
          controller: _addressCtrl,
          maxLines: 4,
          minLines: 3,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(hintText: 'Enter your address'),
        ),
      ],
    );
  }

  // Save Changes — ElevatedButton with theme defaults, pops on tap
  Widget _buildSaveButton(bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : _onSave,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.background,
              ),
            )
          : const Text('Save Changes'),
    );
  }
}
