# Flutter Básico - Guia para Leigos

## Explicação do main.dart

### 📦 PARTE 1: Imports
```dart
import 'package:flutter/material.dart';
```
**O que é:** Importar bibliotecas (ferramentas que você vai usar).

**Analogia:** Pegar ferramentas de uma caixa antes de começar um trabalho.

---

### 🚀 PARTE 2: Ponto de entrada
```dart
void main() {
  runApp(const MyApp());
}
```
**O que é:** Onde o app começa (chave de ignição).

---

### 📱 PARTE 3: MyApp
```dart
class MyApp extends StatelessWidget {
  return ShadApp(
    title: 'App Igreja',
    home: const MainShell(),
  );
}
```
**O que é:** Configuração geral do app (nome, tema, tela inicial).

**StatelessWidget** = Widget que não muda.

---

### 🏠 PARTE 4: MainShell
```dart
class MainShell extends StatefulWidget {
  State<MainShell> createState() => _MainShellState();
}
```
**O que é:** Tela principal que pode mudar.

**StatefulWidget** = Widget que pode mudar (menu embaixo muda de página).

---

### 🧠 PARTE 5: Estado
```dart
class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [HomePage(), ...];
```
**O que é:** Memória da tela.

- `_currentIndex` → Em qual aba estou? (0 = Home, 1 = Favoritos)
- `_pages` → Lista de páginas disponíveis

---

### 🎨 PARTE 6: Build
```dart
Widget build(BuildContext context) {
  return Scaffold(...);
}
```
**O que é:** Desenhar a tela. Toda vez que algo muda, redesenha.

---

### 🏗️ PARTE 7: Scaffold
```dart
Scaffold(
  body: ...,           // Conteúdo principal
  bottomNavigationBar: ... // Menu embaixo
)
```
**O que é:** Estrutura da tela (planta de uma casa).

---

### 📚 PARTE 8: IndexedStack
```dart
IndexedStack(
  index: _currentIndex,
  children: _pages,
)
```
**O que é:** Pilha de páginas. O `index` diz qual está visível.

**Analogia:** 4 cartas empilhadas, o index diz qual está por cima.

---

### 📍 PARTE 9: BottomNavigationBar
```dart
BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) {
    setState(() => _currentIndex = index);
  },
)
```
**O que é:** Menu de navegação embaixo.

- `onTap` → Quando clicar, atualiza o index
- `setState()` → Avisa Flutter para redesenhar

---

## Perguntas e Respostas

### Q: O que é StatelessWidget e StatefulWidget? Por que precisa extender?

**StatelessWidget:** Widget que **não muda** (estático).
- Exemplo: tela de login que só mostra formulário

**StatefulWidget:** Widget que **pode mudar** (dinâmico).
- Exemplo: contador que aumenta, menu que troca de aba

**Por que extender?** No Flutter, tudo é widget. Você **herda** as capacidades base do Flutter para criar seu próprio widget customizado.

---

### Q: const MyApp({super.key}) - o que significa? Por que super.key?

```dart
const MyApp({super.key});
```

- `const` → otimização (widget nunca muda)
- `{super.key}` → passa a chave única para o widget pai (Flutter usa internamente para identificar widgets)

**Por que sempre fazer?** É obrigatório para o Flutter gerenciar widgets corretamente. Pense como "RG do widget".

---

### Q: O que é @override?

```dart
@override
Widget build(BuildContext context) { ... }
```

**O que é:** Indica que você está **sobrescrevendo** um método da classe pai.

**Analogia:** Você herdou uma receita de bolo da sua avó, mas vai modificar os ingredientes. O `@override` avisa "estou mudando a receita original".

---

### Q: O que é BuildContext context?

```dart
Widget build(BuildContext context) { ... }
```

**O que é:** Informações sobre onde o widget está na árvore de widgets.

**Para que serve:** Acessar tema, navegação, tamanho da tela, etc.

```dart
final theme = ShadTheme.of(context); // pega tema usando context
```

---

### Q: O que é ShadApp?

```dart
return ShadApp(
  title: 'App Igreja',
  home: const MainShell(),
);
```

**O que é:** Widget raiz do Shadcn UI (biblioteca de componentes).

**Equivalente:** No Flutter puro seria `MaterialApp`. O ShadApp adiciona tema e componentes do Shadcn UI.

---

### Q: O que é State<MainShell>?

```dart
State<MainShell> createState() => _MainShellState();
```

**O que é:** Tipo genérico indicando que `_MainShellState` é o estado do `MainShell`.

**Analogia:** É o "cérebro" do MainShell que guarda informações (index da página atual).

---

### Q: Por que criar _MainShellState com underline?

```dart
class MainShell extends StatefulWidget { }
class _MainShellState extends State<MainShell> { }
```

**Por que dois arquivos?** Padrão do Flutter para StatefulWidget:
1. `MainShell` → casca (não muda)
2. `_MainShellState` → estado interno (muda)

**Underline (_):** Indica que é **privado**. Só pode ser usado neste arquivo.

---

### Q: _currentIndex = 0 está correto? Parece estranho

```dart
int _currentIndex = 0;
```

**Sim, está correto e profissional.** É o padrão Flutter:
- `_` → privado
- `currentIndex` → nome descritivo
- `= 0` → começa na primeira aba (Home)

---

### Q: O que é final? E List<Widget>? É como TypeScript?

```dart
final List<Widget> _pages = const [
  HomePage(),
  FavoritesPage(),
];
```

**final:** Variável que **não pode ser reatribuída** (mas conteúdo pode mudar em alguns casos).

```dart
final x = 10;
x = 20; // ERRO! Não pode mudar
```

**List<Widget>:** Sim, é como TypeScript!
- `List` → array/lista
- `<Widget>` → tipo genérico (lista de widgets)

**_pages:** Underline = privado.

---

### Q: Por que final List<Widget> = const?

```dart
final List<Widget> _pages = const [...];
```

**final:** Referência não muda (não posso fazer `_pages = outraLista`)

**const:** Conteúdo é constante (lista nunca muda, performance melhor)

**Analogia:**
- `final` → caixa lacrada (não troco a caixa)
- `const` → caixa lacrada com conteúdo fixo (não adiciono/removo itens)

---

### Q: O que é ShadTheme? Por que ShadTheme.of(context)?

```dart
final theme = ShadTheme.of(context);
```

**ShadTheme:** Sistema de tema do Shadcn UI (cores, fontes, estilos).

**ShadTheme.of(context):** Método para **pegar** o tema do contexto atual.

**Uso:**
```dart
theme.colorScheme.primary // cor primária
theme.textTheme.h2        // estilo de título
```

---

### Q: O que é Scaffold?

```dart
Scaffold(
  backgroundColor: ...,
  body: SafeArea(...),
  bottomNavigationBar: ...,
)
```

**O que é:** Estrutura básica de tela do Material Design.

**Componentes:**
- `body` → conteúdo principal
- `bottomNavigationBar` → menu embaixo
- `appBar` → barra no topo (não usamos)
- `drawer` → menu lateral (não usamos)

---

### Q: Linha 44 é o padrão de todas as telas?

```dart
Widget build(BuildContext context) {
  final theme = ShadTheme.of(context);

  return Scaffold(
    body: SafeArea(
      child: IndexedStack(...),
    ),
    bottomNavigationBar: ...,
  );
}
```

**Não exatamente.** Depende do tipo de tela:

**Tela com menu embaixo (nossa):**
```dart
Scaffold(
  body: ...,
  bottomNavigationBar: ...,
)
```

**Tela simples:**
```dart
Scaffold(
  body: Center(
    child: Text('Olá'),
  ),
)
```

**SafeArea:** Garante que conteúdo não fique atrás do notch/barra de status.

**IndexedStack:** Troca entre páginas sem perder estado.

---

## Resumo dos Conceitos

| Conceito | Significado |
|----------|-------------|
| `StatelessWidget` | Widget estático (não muda) |
| `StatefulWidget` | Widget dinâmico (pode mudar) |
| `const` | Valor constante (otimização) |
| `final` | Referência imutável |
| `_variavel` | Privado (só neste arquivo) |
| `super.key` | Identificador único do widget |
| `@override` | Sobrescrever método da classe pai |
| `BuildContext` | Informações do widget na árvore |
| `setState()` | Avisa Flutter para redesenhar |
| `Scaffold` | Estrutura básica de tela |
| `List<Tipo>` | Lista tipada (como TS) |

---

## Fluxo de uma mudança de aba

```
1. Usuário clica em "Favoritos" no menu
2. onTap detecta clique → index = 1
3. setState() é chamado
4. Flutter sabe que precisa redesenhar
5. build() é executado novamente
6. IndexedStack mostra página index 1 (FavoritesPage)
```
