import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/services/user_data_service.dart';
import 'package:redesigned/screens/profile/user_profile_view_model.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProfileViewModel(context.read<UserDataService>()),
      child: const _UserProfileContent(),
    );
  }
}

class _UserProfileContent extends StatelessWidget {
  const _UserProfileContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserProfileViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile",
            style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
              onPressed: viewModel.isDirty ? viewModel.saveProfile : null,
              icon: const Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    child:
                        Icon(Icons.person, size: 64, color: colorScheme.primary),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField(
                label: "Display Name",
                controller: viewModel.displayNameController,
                colorScheme: colorScheme),
            const SizedBox(height: 16),
            _buildTextField(
                label: "User Name",
                controller: viewModel.userNameController,
                colorScheme: colorScheme),
            const SizedBox(height: 16),
            _buildTextField(
                label: "Bio",
                controller: viewModel.bioController,
                colorScheme: colorScheme,
                maxLines: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required ColorScheme colorScheme,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
