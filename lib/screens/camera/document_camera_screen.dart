import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DocumentCameraScreen extends StatefulWidget {
  final Function(List<String> capturedFileNames) onCaptureCompleted;

  const DocumentCameraScreen({
    super.key,
    required this.onCaptureCompleted,
  });

  @override
  State<DocumentCameraScreen> createState() => _DocumentCameraScreenState();
}

class _DocumentCameraScreenState extends State<DocumentCameraScreen> {
  bool _flashOn = false;
  bool _isCapturing = false;
  final List<String> _capturedPages = [];

  void _triggerCapture() {
    if (_isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isCapturing = false;
          _capturedPages.add('Scanned_Page_${_capturedPages.length + 1}.jpg');
        });
      }
    });
  }

  void _finish() {
    if (_capturedPages.isEmpty) {
      _capturedPages.add('Scanned_Prescription_Doc.jpg');
    }
    widget.onCaptureCompleted(_capturedPages);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Viewfinder Background Simulation
            Column(
              children: [
                // Top controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'DOCUMENT SCANNER',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          letterSpacing: 1.2,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _flashOn ? Icons.flash_on : Icons.flash_off,
                          color: _flashOn ? Colors.amber : Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          setState(() => _flashOn = !_flashOn);
                        },
                      ),
                    ],
                  ),
                ),

                // Viewfinder Frame
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Stack(
                      children: [
                        // Simulated Camera Live Stream
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C222E),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.document_scanner,
                                  size: 64,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Keep all four corners inside the guide',
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Corner guides
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppColors.primaryFixed, width: 4),
                                left: BorderSide(color: AppColors.primaryFixed, width: 4),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppColors.primaryFixed, width: 4),
                                right: BorderSide(color: AppColors.primaryFixed, width: 4),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppColors.primaryFixed, width: 4),
                                left: BorderSide(color: AppColors.primaryFixed, width: 4),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppColors.primaryFixed, width: 4),
                                right: BorderSide(color: AppColors.primaryFixed, width: 4),
                              ),
                            ),
                          ),
                        ),

                        // Shutter Flash Animation
                        if (_isCapturing)
                          Container(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                      ],
                    ),
                  ),
                ),

                // Hint Caption
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    'Hold steady · avoid shadows · capture one page at a time',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Bottom Controls: Thumbnails, Shutter, Done
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page count badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF263238),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.copy, size: 16, color: Colors.white70),
                            const SizedBox(width: 6),
                            Text(
                              '${_capturedPages.length} pages',
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      // Circular Shutter Button
                      GestureDetector(
                        onTap: _triggerCapture,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Center(
                            child: Container(
                              width: 58,
                              height: 58,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Done button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onPressed: _capturedPages.isNotEmpty ? _finish : () => Navigator.pop(context),
                        child: Text(_capturedPages.isNotEmpty ? 'Done' : 'Cancel'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
