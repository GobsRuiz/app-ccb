# cloud.md — Guia Pessoal (versão objetiva)

**Propósito:** arquivo de referência pessoal para o assistente de código seguir *antes* de propor ou alterar código. É curto, objetivo e focado em validação da solução, segurança (OWASP) e práticas de revisão. Não contém instruções de execução nem bibliotecas específicas.
**Stacks:** Flutter, Shadcn UI
**Para testes:** Android studio emulador para testar android que é usado normalmente e dispositivo IOS físico para testes quando necessário.
---

## 1. Diretriz geral (passo a passo)

1. **Entender a demanda**

   * Leia e extraia: objetivo, entradas esperadas, saída esperada, restrições, stack técnica e arquivos afetados.

2. **Propor solução em alto nível (SEM IMPLEMENTAR)**

   * Forneça um resumo curto (2–6 linhas) do que será implementado: principais módulos, endpoints, componentes ou mudanças de UI.
   * Liste pressupostos que você fez para propor essa solução.

3. **Autoavaliação crítica** — obrigatória antes de qualquer código:

   * **Compatibilidade:** a solução é compatível com a stack e o framework/tecnologia/stack do projeto?
   * **Segurança:** há validação/escape adequados? Alguma superfície nova de ataque? Precisamos de proteção CSRF, validação de input, ou controle de acesso? (ver seção de segurança)
   * **Performance:** algoritmos e consultas são eficientes? Há risco de bloquear event loop ou gerar consultas pesadas?
   * **Manutenibilidade:** código será simples, modular e com responsabilidade única?
   * **Escopo:** a implementação cria mudanças fora do solicitado? Se sim, interrompa e relate.
   * **Outras questões:** O código tá profissional? Segue boas práticas? Resolve o problema ou cria outro problema? Tem redundancia? Tem algum bug ou falha? Tem duplicata de código?

4. **Ajuste** — se qualquer item acima falhar, refine a proposta e repita a autoavaliação.

5. **Resumo final para revisão (ENVIAR AO USUÁRIO)**

   * Um parágrafo claro e curto (3–6 linhas) com: *o que será feito, por que, arquivos principais que serão alterados, riscos conhecidos.*
   * Não implementar o código/solução ainda. Aguarde aprovação do usuário.

6. **Após aprovação do usuário**

   * Implementar **apenas** o que foi aprovado.
   * Testar localmente e documentar o que foi implementado/ajustado. Documente na pasta /implementacoes, crie um arquivo de acordo com a implementação/ajuste, no nome tem que ter no final o dia, mes, hora e minuto.
   * Preparar o texto que o usuário usará para fazer commit (mensagem de acordo com o conventional commits, lista de arquivos).

---

## 2. Boas práticas de implementação (objetivo e conciso)

* **Simplicidade primeiro:** prefira a solução mais simples que resolve o problema. Evite abstrações complexas se não necessárias.
* **Código com única responsabilidade:** funções/componentes pequenos e claros.
* **Nomes descritivos:** variáveis e funções devem dizer claramente o que fazem.
* **Sem comentários desnecessários:** refatore em vez de comentar o óbvio. Use comentários apenas quando a lógica é inevitavelmente complexa.
* **Validação e sanitização:** valide todas as entradas no servidor; use allowlists sempre que possível.
* **Não alterar arquivos fora do escopo:** qualquer mudança fora do solicitado deve ser aprovada explicitamente.
* **Tratamento de erros (ver seção dedicada):** obrigatória e consistente em toda a stack.

---

## 3. Tratamento de erros — como fazer

**Princípios chaves:**

* Nunca ignore erros. Capture, normalize e responda de forma consistente.
* Não vazar informações sensíveis nas respostas ao cliente.
* Tenha um formato de erro padrão (código, mensagem curta, detalhes opcionais não sensíveis).

**Padrão de implementação por tipo de projeto (descrição, não execuções):**

---

## 4. Segurança (diretrizes OWASP)

* **Atualizar dependências:** verifique vulnerabilidades conhecidas antes de deploy e atualize quando seguro.
* **Não vazar segredos:** use variáveis de ambiente; não inserir chaves ou segredos no código.
* **Proteção de input:** valide e sanitize tudo no servidor; use allowlists para campos e tipos.
* **Autenticação e autorização:** aplique mínimo privilégio (RBAC ou escopos); proteja endpoints críticos.
* **Proteção contra CSRF/XSS/Injection:** evite inserir HTML arbitrário; valide e escape saída quando necessário; evite construir consultas via concatenação sem parametrização.
* **Rate limit e proteção contra força bruta:** para endpoints sensíveis (login, reset) aplique limitação de requisições e bloqueios graduais.
* **Cookies e sessões:** configure flags de segurança (HttpOnly, Secure, SameSite) quando usar cookies.
* **Validação no servidor sempre:** o front-end nunca substitui checagens de servidor.

---

## 5. Proibições (regras rígidas)

* **Não** implementar ou alterar algo fora do escopo aprovado.
* **Não** mudar arquivos de infraestrutura, configuração ou deploy sem aprovação explícita.
* **Não** usar técnicas que executem código arbitrário (ex.: eval) ou que criem superfícies desnecessárias de ataque.
* **Não** incluir dados sensíveis em respostas, commits ou mensagens de revisão.

---

## 6. Processo de entrega / texto para commit (o que eu como usuário quero receber)

Quando finalizar a implementação, **o assistente deve me entregar apenas texto** (não executar commits). Esse texto deve conter:

1. **Lista de arquivos alterados:** caminho relativo e breve descrição por arquivo (1 linha cada).

2. **Mensagem de commit sugerida (Conventional Commits:** formato):

   * Linha de título (1 linha): `tipo(escopo): descrição curta`.

3. **Resumo das verificações realizadas:** pontos testados (ex.: casos de sucesso, erros, validação de input), e resultado (ok / nota sobre risco).

4. **Instruções pós-commit (o que o revisor/deployer precisa saber):** migrações, passos de build, variáveis de ambiente novas, e qualquer atenção especial.

**Exemplo conciso que o assistente deve devolver (texto):**

* Branch: `feat/auth-refresh`
* Arquivos alterados:

  * `src/controllers/auth.js` — adicionar rota de refresh token
  * `src/services/token.js` — gerar/validar refresh tokens
* Commit sugerido: `feat(auth): adicionar refresh token endpoint`
* Verificações: 1) fluxo de refresh com token válido (ok), 2) refresh com token expirado (erro tratado), 3) validação de input (ok)
* Observações: adicionar `REFRESH_TOKEN_SECRET` nas variáveis de ambiente.

---

## 7. Observações finais

* Este arquivo é um padrão base. Para cada projeto/stack, faremos uma versão específica (mesma lógica, ajustes de segurança e checklist por stack).
* Sempre esperar aprovação do usuário antes de qualquer implementação ou alteração fora do escopo.

---
