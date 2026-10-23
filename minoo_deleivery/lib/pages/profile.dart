import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minoo_deleivery/pages/CartPage.dart';
import 'package:minoo_deleivery/pages/forgot_password.dart';
import 'package:minoo_deleivery/pages/order_history.dart';
import 'package:minoo_deleivery/services/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onLogOut;

  const ProfilePage({super.key, this.onLogOut});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color primaryColor = const Color(0xfff59e0b);

  void _showEditProfileDialog(Map<String, dynamic>? userData, User user) {
    final nameController = TextEditingController(
      text: userData?['name'] ?? user.displayName ?? '',
    );
    final phoneController = TextEditingController(
      text: userData?['phone'] ?? '',
    );

    String? dialogError;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                top: 24,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Full Name Field
                  const Text(
                    "Full Name",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter full name",
                        prefixIcon: Icon(Icons.person_outline, color: Color(0xfff59e0b)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone Number Field
                  Row(
                    children: [
                      const Text(
                        "Phone Number",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xfff59e0b).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "09... or 07...",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffd97706),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        hintText: "09XXXXXXXX or 07XXXXXXXX",
                        prefixIcon: Icon(Icons.phone_android_rounded, color: Color(0xfff59e0b)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),

                  if (dialogError != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              dialogError!,
                              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      onPressed: isSaving
                          ? null
                          : () async {
                              final newName = nameController.text.trim();
                              final newPhone = phoneController.text.trim();

                              if (newName.isEmpty) {
                                setSheetState(() => dialogError = "Name cannot be empty");
                                return;
                              }
                              final phoneErr = AuthService.validateEthiopianPhone(newPhone);
                              if (phoneErr != null) {
                                setSheetState(() => dialogError = phoneErr);
                                return;
                              }

                              setSheetState(() {
                                isSaving = true;
                                dialogError = null;
                              });

                              try {
                                await AuthService.updateProfileData(
                                  uid: user.uid,
                                  name: newName,
                                  phone: newPhone,
                                );
                                if (sheetContext.mounted) {
                                  Navigator.pop(sheetContext);
                                }
                                if (mounted) {
                                  ScaffoldMessenger.of(this.context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text("Profile updated successfully!"),
                                    ),
                                  );
                                }
                              } catch (e) {
                                setSheetState(() {
                                  isSaving = false;
                                  dialogError = e.toString();
                                });
                              }
                            },
                      child: isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Text(
                              "Save Changes",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmLogOut() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent, size: 26),
            SizedBox(width: 10),
            Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          "Are you sure you want to log out of Minoo Delivery?",
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await AuthService.logOut();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Logged out successfully"),
                    duration: Duration(seconds: 2),
                  ),
                );
                if (widget.onLogOut != null) {
                  widget.onLogOut!();
                }
              }
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    if (user == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                "You are not logged in",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Log in or create an account to view and manage your profile.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text("Log In / Sign Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: AuthService.userStream(user.uid),
      builder: (context, snapshot) {
        final userData = snapshot.data?.data();
        final displayName = userData?['name'] ?? user.displayName ?? 'Customer';
        final email = userData?['email'] ?? user.email ?? 'No email';
        final phone = userData?['phone'] ?? 'No phone added';
        final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
        final String? photoUrl = userData?['photoUrl'] ?? user.photoURL;

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 90),
          child: Column(
            children: [
              // Top Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 24, bottom: 28, left: 20, right: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xfff59e0b), Color(0xffd97706)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (Navigator.canPop(context)) ...[
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 4),
                            ],
                            const Text(
                              "My Profile",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
                          tooltip: "Edit Profile",
                          onPressed: () => _showEditProfileDialog(userData, user),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Avatar
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: Colors.white,
                          child: (photoUrl != null && photoUrl.trim().isNotEmpty)
                              ? CircleAvatar(
                                  radius: 42,
                                  backgroundImage: NetworkImage(photoUrl),
                                  onBackgroundImageError: (_, __) {},
                                  child: null,
                                )
                              : CircleAvatar(
                                  radius: 42,
                                  backgroundColor: const Color(0xFFFEF3C7),
                                  child: Text(
                                    initial,
                                    style: const TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffd97706),
                                    ),
                                  ),
                                ),
                        ),
                        GestureDetector(
                          onTap: () => _showEditProfileDialog(userData, user),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 4),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Color(0xfff59e0b),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // User Name
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Email with Verified pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            email,
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Personal Information Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Account Information",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C2C2C),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _showEditProfileDialog(userData, user),
                              icon: const Icon(Icons.edit, size: 16, color: Color(0xfff59e0b)),
                              label: const Text(
                                "Edit",
                                style: TextStyle(
                                  color: Color(0xfff59e0b),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        _infoTile(
                          icon: Icons.person_outline,
                          title: "Full Name",
                          value: displayName,
                        ),
                        _infoTile(
                          icon: Icons.phone_android_rounded,
                          title: "Ethiopian Phone",
                          value: phone,
                          badge: (phone.startsWith("09") || phone.startsWith("07")) ? "Verified" : null,
                        ),
                        _infoTile(
                          icon: Icons.email_outlined,
                          title: "Email",
                          value: email,
                        ),
                        _infoTile(
                          icon: Icons.badge_outlined,
                          title: "Account Type",
                          value: (userData?['role'] ?? 'Customer').toString().toUpperCase(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Quick Actions Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    children: [
                      _actionTile(
                        icon: Icons.receipt_long_rounded,
                        color: const Color(0xfff59e0b),
                        title: "My Order History",
                        subtitle: "View current and past food deliveries",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const OrderHistoryPage()),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 64),
                      _actionTile(
                        icon: Icons.shopping_cart_outlined,
                        color: Colors.blueAccent,
                        title: "My Cart",
                        subtitle: "Check selected dishes and prepare order",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Cartpage()),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 64),
                      _actionTile(
                        icon: Icons.lock_reset_rounded,
                        color: Colors.deepPurpleAccent,
                        title: "Reset / Change Password",
                        subtitle: "Send 6-digit email OTP to reset password",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ForgotPassword()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Log Out Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                    label: const Text(
                      "Log Out",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: Colors.red.shade50.withValues(alpha: 0.5),
                    ),
                    onPressed: _confirmLogOut,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
    String? badge,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFececf8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xfff59e0b), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
