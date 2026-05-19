import 'package:flutter/material.dart';
import 'package:tdd_example/core/router/routes.dart';

enum ToastType { success, error, warning, info }

class AppToast extends StatefulWidget {
  final String title;
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  const AppToast({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<AppToast> createState() => _AppToastState();
}

class _AppToastState extends State<AppToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  _ToastConfig get _config => switch (widget.type) {
    ToastType.success => _ToastConfig(
      icon: Icons.check_circle_outline_rounded,
      iconColor: const Color(0xFF3B6D11),
      bg: const Color(0xFFEAF3DE),
      border: const Color(0xFF97C459),
      titleColor: const Color(0xFF27500A),
      msgColor: const Color(0xFF3B6D11),
    ),
    ToastType.error => _ToastConfig(
      icon: Icons.error_outline_rounded,
      iconColor: const Color(0xFF791F1F),
      bg: const Color(0xFFFCEBEB),
      border: const Color(0xFFF09595),
      titleColor: const Color(0xFF501313),
      msgColor: const Color(0xFF791F1F),
    ),
    ToastType.warning => _ToastConfig(
      icon: Icons.warning_amber_rounded,
      iconColor: const Color(0xFF633806),
      bg: const Color(0xFFFAEEDA),
      border: const Color(0xFFEF9F27),
      titleColor: const Color(0xFF412402),
      msgColor: const Color(0xFF633806),
    ),
    ToastType.info => _ToastConfig(
      icon: Icons.info_outline_rounded,
      iconColor: const Color(0xFF0C447C),
      bg: const Color(0xFFE6F1FB),
      border: const Color(0xFF85B7EB),
      titleColor: const Color(0xFF042C53),
      msgColor: const Color(0xFF0C447C),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final cfg = _config;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: cfg.bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cfg.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(cfg.icon, color: cfg.iconColor, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cfg.titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.message,
                      style: TextStyle(fontSize: 13, color: cfg.msgColor),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: dismiss,
                child: Icon(Icons.close, size: 18, color: cfg.msgColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToastConfig {
  final IconData icon;
  final Color iconColor, bg, border, titleColor, msgColor;

  const _ToastConfig({
    required this.icon,
    required this.iconColor,
    required this.bg,
    required this.border,
    required this.titleColor,
    required this.msgColor,
  });
}

class ToastHelper {
  static OverlayEntry? _current;

  static void show({
    required String title,
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    _current?.remove();
    _current = null;

    // ✅ navigatorKey orqali emas, to'g'ridan-to'g'ri overlay state'ni ol
    final overlayState = router.navigatorKey.currentState?.overlay;
    if (overlayState == null) return;

    final context = router.navigatorKey.currentContext!;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: MediaQuery.of(context).padding.top + 12,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: AppToast(
            title: title,
            message: message,
            type: type,
            onDismiss: () {
              entry.remove();
              _current = null;
            },
          ),
        ),
      ),
    );

    _current = entry;
    overlayState.insert(entry); // ✅ to'g'ridan-to'g'ri overlayState.insert()

    Future.delayed(duration, () {
      if (_current == entry) {
        entry.remove();
        _current = null;
      }
    });
  }

  // Convenience metodlar
  static void success(String message, {String title = 'Muvaffaqiyatli!'}) =>
      show(title: title, message: message, type: ToastType.success);

  static void error(String message, {String title = 'Xatolik!'}) =>
      show(title: title, message: message, type: ToastType.error);

  static void warning(String message, {String title = 'Diqqat!'}) =>
      show(title: title, message: message, type: ToastType.warning);

  static void info(String message, {String title = "Ma'lumot"}) =>
      show(title: title, message: message, type: ToastType.info);
}
