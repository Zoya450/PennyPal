import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:penny_pal/providers/auth_provider.dart';
import 'package:penny_pal/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthProvider>(context, listen: false).currentUserData;
      if (user != null) {
        _nameController.text = user.fullName;
        _mobileController.text = user.mobileNumber;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final userId = auth.currentUserData?.userId;
      
      if (userId != null) {
        await DatabaseService().updateUser(userId, {
          'fullName': _nameController.text.trim(),
          'mobileNumber': _mobileController.text.trim(),
        });
        await auth.refreshUser();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAccount() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone and all your data will be lost.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        final userId = auth.currentUserData?.userId;
        if (userId != null) {
          // Delete from Firestore
          await DatabaseService().deleteUser(userId);
          // Delete from Firebase Auth
          await FirebaseAuth.instance.currentUser?.delete();
          // Log out
          await auth.logout();
          if (mounted) {
             Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        }
      } catch (e) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete account. You may need to log out and log back in to verify your identity. Error: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = Provider.of<AuthProvider>(context).currentUserData;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile Settings'),
        backgroundColor: colorScheme.surface,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Edit Your Information', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Enter your mobile number' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: user?.email,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email (Cannot be changed)',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: _updateProfile,
                      child: const Text('Save Changes'),
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Divider(),
                  const SizedBox(height: 24),
                  Text('Danger Zone', style: theme.textTheme.titleMedium?.copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _deleteAccount,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Delete Account'),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
