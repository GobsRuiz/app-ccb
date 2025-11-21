import 'package:flutter/material.dart';

/// Classe centralizada para tratamento de erros
/// Responsável por logging e exibição de erros ao usuário
class ErrorHandler {
  /// Faz log do erro para debug e futuramente para serviços de monitoramento
  ///
  /// [error] - O erro que ocorreu
  /// [stack] - Stack trace do erro (opcional)
  /// [context] - Contexto adicional sobre onde o erro ocorreu (opcional)
  static void handle(Object error, StackTrace? stack, {String? context}) {
    // Log para debug
    debugPrint('=== ERROR ===');
    if (context != null) {
      debugPrint('Context: $context');
    }
    debugPrint('Error: $error');
    if (stack != null) {
      debugPrint('Stack trace:');
      debugPrint(stack.toString());
    }
    debugPrint('=============');

    // TODO: Em produção, enviar para serviço de monitoramento
    // if (kReleaseMode) {
    //   FirebaseCrashlytics.instance.recordError(error, stack, reason: context);
    // }
  }

  /// Mostra erro ao usuário usando toast
  ///
  /// [context] - BuildContext para mostrar o toast
  /// [message] - Mensagem de erro amigável para o usuário
  static void showToUser(BuildContext context, String message) {
    // Verifica se o context ainda está montado
    if (!context.mounted) {
      debugPrint('Cannot show error: context not mounted. Message: $message');
      return;
    }

    // Usa FToast do Forui para mostrar erro
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFDC2626), // Vermelho de erro
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
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
    );

    overlay.insert(overlayEntry);

    // Remove após 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
