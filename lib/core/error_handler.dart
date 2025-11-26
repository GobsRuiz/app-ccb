import 'package:flutter/material.dart';
import '../services/toast_service.dart';

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
    ToastService.showError(context, message);
  }
}
