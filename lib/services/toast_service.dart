import 'package:flutter/material.dart';

/// Tipos de toast disponíveis
enum ToastType {
  success,
  error,
  warning,
  info,
}

/// Configuração visual para cada tipo de toast
class _ToastConfig {
  final Color color;
  final IconData icon;

  const _ToastConfig(this.color, this.icon);
}

/// Representação de um toast ativo (para gerenciamento de fila)
class _ActiveToast {
  final OverlayEntry overlayEntry;
  final AnimationController controller;

  _ActiveToast(this.overlayEntry, this.controller);
}

/// Serviço centralizado para exibição de notificações/toasts
/// Fornece interface unificada e consistente para alertas ao usuário
class ToastService {
  /// Configurações visuais por tipo
  static const _configs = {
    ToastType.success: _ToastConfig(Color(0xFF16A34A), Icons.check_circle_outline),
    ToastType.error: _ToastConfig(Color(0xFFDC2626), Icons.error_outline),
    ToastType.warning: _ToastConfig(Color(0xFFEA580C), Icons.warning_amber_outlined),
    ToastType.info: _ToastConfig(Color(0xFF2563EB), Icons.info_outline),
  };

  /// Lista de toasts ativos para gerenciamento de fila
  static final List<_ActiveToast> _activeToasts = [];

  /// Mostra toast de sucesso
  static void showSuccess(BuildContext context, String message, {Duration? duration}) {
    _show(context, message, ToastType.success, duration: duration);
  }

  /// Mostra toast de erro
  static void showError(BuildContext context, String message, {Duration? duration}) {
    _show(context, message, ToastType.error, duration: duration);
  }

  /// Mostra toast de aviso
  static void showWarning(BuildContext context, String message, {Duration? duration}) {
    _show(context, message, ToastType.warning, duration: duration);
  }

  /// Mostra toast informativo
  static void showInfo(BuildContext context, String message, {Duration? duration}) {
    _show(context, message, ToastType.info, duration: duration);
  }

  /// Remove todos os toasts ativos
  static void clearAll() {
    for (final toast in _activeToasts) {
      toast.controller.stop();
      if (toast.overlayEntry.mounted) {
        toast.overlayEntry.remove();
      }
      toast.controller.dispose();
    }
    _activeToasts.clear();
  }

  /// Método interno para exibir toast
  static void _show(
    BuildContext context,
    String message,
    ToastType type, {
    Duration? duration,
  }) {
    // Verifica se context está montado
    if (!context.mounted) {
      debugPrint('Cannot show toast: context not mounted. Message: $message');
      return;
    }

    // Remove todos os toasts anteriores para evitar duplicatas
    clearAll();

    final config = _configs[type]!;
    final overlay = Overlay.of(context);

    // Cria AnimationController para animação de entrada
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: overlay,
    );

    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutCubic,
    ));

    final opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 0,
        right: 0,
        child: SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: opacityAnimation,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: config.color,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            config.icon,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              message,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Adiciona à lista de toasts ativos
    final activeToast = _ActiveToast(overlayEntry, animationController);
    _activeToasts.add(activeToast);

    // Inicia animação de entrada
    animationController.forward();

    // Remove após duração especificada
    final toastDuration = duration ?? const Duration(seconds: 3);
    Future.delayed(toastDuration, () async {
      // Animação de saída
      await animationController.reverse();

      // Remove da lista de ativos
      _activeToasts.remove(activeToast);

      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
      animationController.dispose();
    });
  }
}
