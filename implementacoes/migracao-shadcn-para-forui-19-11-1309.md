# Migração Completa: Shadcn UI → Forui

**Data:** 19/11/2025 13:09
**Tipo:** Migração de UI Library
**Status:** ✅ Concluída

---

## Resumo

Migração completa de 100% do projeto Flutter de **Shadcn UI** para **Forui**, conforme solicitado pelo usuário. Todos os arquivos foram atualizados, dependências substituídas, e a compilação está sem erros.

---

## Motivação

- Substituir Shadcn UI pelo Forui como biblioteca de UI padrão do projeto
- Forui oferece 40+ widgets, CLI para temas, e melhor integração com Flutter moderno
- Ambas bibliotecas são inspiradas no shadcn/ui, facilitando transição visual

---

## Alterações Realizadas

### 1. Dependências (pubspec.yaml)

**Removido:**
```yaml
shadcn_ui: ^0.39.7
```

**Adicionado:**
```yaml
forui: ^0.16.0
```

**SDK atualizado:**
```yaml
environment:
  sdk: ^3.35.0  # era ^3.10.0
```

---

### 2. Estrutura do App (lib/main.dart)

**Antes (Shadcn UI):**
```dart
import 'package:shadcn_ui/shadcn_ui.dart';

return ShadApp(
  title: 'App Igreja',
  themeMode: ThemeMode.light,
  home: const MainShell(),
);
```

**Depois (Forui):**
```dart
import 'package:forui/forui.dart';

return MaterialApp(
  title: 'App Igreja',
  theme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
  ),
  home: FTheme(
    data: FThemes.zinc.light,
    child: const MainShell(),
  ),
);
```

**Acessos ao tema atualizados:**
- `ShadTheme.of(context)` → `context.theme`
- `theme.colorScheme.*` → `theme.colors.*`
- `LucideIcons.*` → `FIcons.*`

---

### 3. Pages Migradas

Todas as 4 páginas foram atualizadas com a mesma estrutura:

#### HomePage, FavoritesPage, NotificationsPage, ProfilePage

**Padrão de migração:**

```dart
// ANTES
import 'package:shadcn_ui/shadcn_ui.dart';

final theme = ShadTheme.of(context);

Icon(
  LucideIcons.house,
  color: theme.colorScheme.primary,
)

Text('Home', style: theme.textTheme.h2)
Text('Bem-vindo ao app', style: theme.textTheme.muted)
```

```dart
// DEPOIS
import 'package:forui/forui.dart';

final theme = context.theme;

Icon(
  FIcons.house,
  color: theme.colors.primary,
)

Text(
  'Home',
  style: theme.typography.xl2.copyWith(
    fontWeight: FontWeight.bold,
    color: theme.colors.foreground,
  ),
)

Text(
  'Bem-vindo ao app',
  style: theme.typography.sm.copyWith(
    color: theme.colors.mutedForeground,
  ),
)
```

---

## Mapeamento de Componentes

### Tema e Cores

| Shadcn UI | Forui | Observações |
|-----------|-------|-------------|
| `ShadApp` | `MaterialApp` + `FTheme` | Forui usa wrapper sobre Material |
| `ShadTheme.of(context)` | `context.theme` | Extensão em BuildContext |
| `theme.colorScheme.*` | `theme.colors.*` | FColors ao invés de ColorScheme |
| `theme.colorScheme.background` | `theme.colors.background` | Propriedade direta |
| `theme.colorScheme.primary` | `theme.colors.primary` | Propriedade direta |
| `theme.colorScheme.mutedForeground` | `theme.colors.mutedForeground` | Propriedade direta |

### Tipografia

| Shadcn UI | Forui |
|-----------|-------|
| `theme.textTheme.h2` | `theme.typography.xl2` |
| `theme.textTheme.muted` | `theme.typography.sm` |

### Ícones

| Shadcn UI | Forui |
|-----------|-------|
| `LucideIcons.house` | `FIcons.house` |
| `LucideIcons.star` | `FIcons.star` |
| `LucideIcons.bell` | `FIcons.bell` |
| `LucideIcons.user` | `FIcons.user` |

*Nota: Forui usa os mesmos ícones Lucide, apenas com prefixo `F`*

---

## Arquivos Modificados

1. **pubspec.yaml** - Atualizado SDK e dependências
2. **lib/main.dart** - Substituído ShadApp por MaterialApp + FTheme
3. **lib/pages/home_page.dart** - Imports e acesso ao tema
4. **lib/pages/favorites_page.dart** - Imports e acesso ao tema
5. **lib/pages/notifications_page.dart** - Imports e acesso ao tema
6. **lib/pages/profile_page.dart** - Imports e acesso ao tema

---

## Verificações Realizadas

✅ **Análise estática:** `flutter analyze` - Nenhum erro
✅ **Imports:** 100% migrados de shadcn_ui para forui
✅ **Tema:** Estrutura correta (`theme.colors.*`, `theme.typography.*`)
✅ **Ícones:** Todos convertidos para `FIcons.*`
✅ **Compatibilidade:** Flutter 3.38.2 > 3.35.0 (requisito Forui) ✓

---

## Comandos Executados

```bash
# 1. Verificar versão Flutter
flutter --version

# 2. Remover Shadcn UI
flutter pub remove shadcn_ui

# 3. Adicionar Forui
flutter pub add forui

# 4. Limpar cache
flutter clean

# 5. Obter dependências
flutter pub get

# 6. Analisar código
flutter analyze
```

---

## Estrutura do FThemeData (Referência)

```
FThemeData
  ├── colors (FColors)
  │   ├── background
  │   ├── foreground
  │   ├── primary
  │   ├── primaryForeground
  │   ├── secondary
  │   ├── secondaryForeground
  │   ├── muted
  │   ├── mutedForeground
  │   ├── destructive
  │   ├── destructiveForeground
  │   ├── error
  │   ├── errorForeground
  │   └── border
  │
  ├── typography (FTypography)
  │   ├── xs, sm, base, lg, xl, xl2, xl3, xl4
  │   └── cada um com: fontSize, height, letterSpacing, fontWeight
  │
  └── style (FStyle)
      ├── borderRadius
      └── outras propriedades
```

---

## Observações Importantes

1. **Estrutura de cores:** Forui usa `colors` (não `colorScheme`)
2. **Acesso ao tema:** Use `context.theme` (extensão BuildContext)
3. **Tipografia:** Forui usa escala numérica (`xl2`, `sm`) vs nomes (`h2`, `muted`)
4. **Compatibilidade:** Forui 0.16.0 requer Flutter 3.35.0+
5. **Ícones bundled:** Forui inclui ícones Lucide, não precisa pacote separado

---

## Próximos Passos Sugeridos

- [ ] Testar app em emulador/dispositivo para validar visualmente
- [ ] Explorar widgets avançados do Forui (40+ disponíveis)
- [ ] Considerar uso do CLI do Forui: `dart run forui style create <widget>`
- [ ] Avaliar temas predefinidos (zinc, slate, blue, etc.)

---

## Conclusão

Migração 100% completa e bem-sucedida. Todos os rastros de Shadcn UI foram removidos do código (restam apenas em docs/referências). O projeto compila sem erros e está pronto para uso com Forui.
