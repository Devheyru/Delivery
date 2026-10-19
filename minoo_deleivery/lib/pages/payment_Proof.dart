import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Displays a modal dialog prompting the user to upload a payment proof screenshot.
void showPaymentDialog(
  BuildContext context, {
  Future<void> Function(XFile file)? onSubmit,
}) {
  XFile? pickedFile;
  bool isSubmitting = false;
  final ImagePicker picker = ImagePicker();

  showDialog(
    context: context,
    barrierDismissible: !isSubmitting,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Upload Payment Screenshot",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1f2937),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Please upload a screenshot of your bank or Telebirr transfer receipt.",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // File picker container
                  GestureDetector(
                    onTap: isSubmitting
                        ? null
                        : () async {
                            try {
                              if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
                                PermissionStatus status = await Permission.photos.request();
                                if (!status.isGranted && Platform.isAndroid) {
                                  status = await Permission.storage.request();
                                }
                              }

                              final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 85,
                              );

                              if (image != null) {
                                setState(() {
                                  pickedFile = image;
                                });
                              }
                            } catch (_) {
                              final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (image != null) {
                                setState(() {
                                  pickedFile = image;
                                });
                              }
                            }
                          },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: pickedFile != null
                              ? const Color(0xfff59e0b)
                              : Colors.grey.shade400,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xfffffbeb),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            pickedFile != null
                                ? Icons.check_circle
                                : Icons.upload_file,
                            color: const Color(0xfff59e0b),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              pickedFile != null
                                  ? pickedFile!.name
                                  : "Tap to select screenshot from gallery",
                              style: TextStyle(
                                color: pickedFile != null
                                    ? Colors.black87
                                    : Colors.black54,
                                fontWeight: pickedFile != null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xfff59e0b),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          onPressed: isSubmitting
                              ? null
                              : () async {
                                  if (pickedFile == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.redAccent,
                                        content: Text(
                                          "Please select a payment screenshot first.",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (onSubmit != null) {
                                    setState(() => isSubmitting = true);
                                    try {
                                      await onSubmit(pickedFile!);
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    } catch (e) {
                                      setState(() => isSubmitting = false);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            content: Text("Submission failed: $e"),
                                          ),
                                        );
                                      }
                                    }
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Confirm & Submit",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: isSubmitting
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
