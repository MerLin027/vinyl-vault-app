import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // ignore: unused_import
import '../config/theme.dart';
import '../widgets/vinyl_logo.dart'; // ignore: unused_import

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Form controllers pre-filled with placeholder profile data
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: 'John Doe');
    _emailCtrl = TextEditingController(text: 'john.doe@example.com');
    _phoneCtrl = TextEditingController(text: '+1 (555) 000-0000');
    _bioCtrl = TextEditingController(
        text: "Audiophile and vintage vinyl collector. Spinning classics since '98.");
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // Save changes and pop back to ProfileScreen
  void _onSave() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                    // Bio multi-line textarea (4 rows)
                    _buildBioField(),
                    const SizedBox(height: 20),
                    // Save Changes primary action button
                    _buildSaveButton(),
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

  // Bio multi-line textarea — 4 visible lines, no resize
  Widget _buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bio label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Bio',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        // Multi-line TextField equivalent of <textarea rows="4">
        TextField(
          controller: _bioCtrl,
          maxLines: 4,
          minLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(hintText: 'Tell us about yourself'),
        ),
      ],
    );
  }

  // Save Changes — ElevatedButton with theme defaults, pops on tap
  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _onSave,
      child: const Text('Save Changes'),
    );
  }
}
