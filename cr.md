# Code review: preset `wcag-2.2`

Data: 2026-11-03  
Zakres: `wcag-2.2/.cursor/**`, `wcag-2.2/README.md`, `README.md`  
Werdykt: **nie jest gotowy na produkcję w 100%.**

Domyślna ścieżka (WCAG 2.2 AA, reguła + skill + tabele) jest blisko używalnego presetu dla zespołu. Nie wolno jej traktować jako gwarancji zgodności WCAG wygenerowanego UI. Cztery rzeczy blokują ocenę „100%”: poziom A/AAA nie jest egzekwowany tam, gdzie model naprawdę dostaje instrukcję; hook przy domyślnej instalacji spowalnia agenta i nie oddaje mu wyników; wzorzec 2.4.11 da się skopiować i nadal nie spełnić kryterium; subagent jest opisany tak, że odpala się po każdej zmianie UI i dubluje skill.

---

## 1. Zależność agent ↔ skill

**Poprawny kierunek jest taki, jak w tym presecie: agent korzysta ze skilla. Skill nie jest właścicielem agenta.**

W Cursorze to są trzy różne mechanizmy:

| Warstwa | Kto działa | Rola |
| --- | --- | --- |
| Rule (`.cursor/rules/*.mdc`) | rodzic, automatycznie | Krótki, twardy kontekst przy pasujących plikach |
| Skill (`.cursor/skills/<nazwa>/SKILL.md`) | nikt sam z siebie | Procedura i wiedza. Ładuje ją ten agent, który akurat pracuje |
| Subagent (`.cursor/agents/*.md`) | osobny agent, własny kontekst | Izolacja, inne uprawnienia (`readonly`), osobne okno |

Skill nie ma runtime’u. Nie może „wywołać” subagenta. Instrukcję „deleguj do `a11y-reviewer`” wykonuje agent, który tę instrukcję przeczytał (tu: rodzic, przez regułę). Subagent z kolei dostaje skill dopiero wtedy, gdy jego prompt każe mu przeczytać `SKILL.md`. To jest właściwy, bezpieczny zapis: subagent nie dziedziczy ciała skilla sam.

Odwrócenie („skill korzysta z agenta”, cienki skill, którego jedyną treścią jest odpalenie subagenta) ma sens tylko wtedy, gdy cała praca ma się wydarzyć w osobnym kontekście. Tu skill jest też playbookiem implementacji („zrób dostępny formularz logowania”). `a11y-reviewer` ma `readonly: true`, więc nie może tej implementacji wykonać. Gdyby skill tylko przekazywał pracę do subagenta, prośby o kod lądowałyby u agenta, który nie może pisać plików.

Docelowy układ:

```text
Agent-rodzic
├── rule          krótkie ograniczenia przy pisaniu UI
├── skill         procedura, kryteria, wzorce, format raportu
└── subagent      opcjonalny, readonly, osobny kontekst
    └── czyta ten sam skill
```

Jedna kopia reguł audytu (tak jest dziś w `SKILL.md`, a subagent tam odsyła) jest właściwa. Druga kopia w prompcie subagenta rozjechałaby się z skillem.

### Czy `a11y-reviewer` jest potrzebny?

Do generowania kodu — nie. Reguła i skill wystarczą, a `/wcag-2.2` i tak ładuje procedurę w bieżącym czacie.

Do audytu — tak, ale tylko w węższej roli, niż mówi dzisiejszy opis:

- osobne okno kontekstu, żeby długi przegląd nie zjadał rozmowy, w której powstaje komponent;
- `readonly: true`, czyli audyt, który nie „naprawia” pliku w trakcie recenzji;
- jawne wejście `/a11y-reviewer`.

Oficjalna wskazówka Cursora: subagent, gdy potrzebna jest niezależna weryfikacja albo izolacja kontekstu; skill, gdy zadanie ma zostać w tym samym oknie. Samo posiadanie obu warstw jest zgodne z platformą. Koszt jest konkretny: każdy start subagenta to drugi kontekst, drugi rachunek tokenów i dodatkowe opóźnienie.

Dziś subagent tej ceny nie zarabia w całości:

- opis mówi „Use proactively after generating or modifying UI”;
- reguła dodatkowo każe rodzicowi delegować głęboki audyt do `a11y-reviewer`;
- ciało subagenta ma osiem linijek i wyłącznie odsyła do skilla.

Efekt: po zmianie UI rodzic może sam wczytać skill i jeszcze odpalić drugiego agenta, który wczyta ten sam skill. Wiedzy przybywa zero, koszt rośnie podwójnie.

Dodatkowo zdanie „Do not rewrite the component unless asked” jest niespełnialne. `readonly: true` blokuje zapis nawet wtedy, gdy użytkownik poprosi `/a11y-reviewer` o poprawkę. Poprawki musi nanieść rodzic. Prompt powinien to mówić wprost.

**Rekomendacja:** zostawić subagenta jako audytora na żądanie. Zdjąć „use proactively” i nie kazać regule delegować po każdym wygenerowanym komponencie. Jeśli zespół nie chce osobnego, płatnego przebiegu audytu, subagenta można usunąć. Preset bez niego dalej działa.

---

## 2. Co jest solidne

- Układ katalogów jest zgodny z Cursorem: `rules/`, `skills/wcag-2.2/SKILL.md`, `agents/`, `hooks.json`. `name: wcag-2.2` zgadza się z nazwą folderu skilla.
- Frontmatter subagenta jest poprawny: `model: inherit` i `readonly: true` są polami z dokumentacji subagentów.
- `SKILL.md` ma 128 linii, referencje są jeden poziom niżej. To jest właściwy progressive disclosure.
- Format raportu, klasy code / hybrid / manual i zakaz twierdzenia „to jest zgodne z WCAG” są w jednym miejscu. To najdojrzalszy fragment presetu.
- Tabele przeliczone skryptem, bez duplikatów:
  - WCAG 2.1: 78 kryteriów, kolumny 30 A / 20 AA / 28 AAA (zgodność AA = 50). Jest 4.1.1. Nie ma dziewięciu kryteriów z 2.2.
  - WCAG 2.2: 86 kryteriów, kolumny 31 A / 24 AA / 31 AAA (zgodność AA = 55). Nie ma 4.1.1. Jest wszystkie 9 nowych.
  - Delta AA: 50 − 1 (4.1.1) + 6 (2.4.11, 2.5.7, 2.5.8, 3.2.6, 3.3.7, 3.3.8) = 55. Zgadza się z `wcag-2.1-vs-2.2.md`.
- Poziomy nowych kryteriów (A / AA / AAA) zgadzają się z rekomendacją W3C. Parafrazy w `new-criteria.md` obejmują wyjątki 2.5.8 i 3.3.8 oraz uwagi 2.4.11.
- Hook przy braku ESLint i przy złym JSON kończy się kodem 0 i `{"continue":true}`. Sprawdzone lokalnie na trzech wejściach (plik nie-UI, `.tsx`, nie-JSON). W tym repozytorium nie ma `package.json` z ESLint, więc ścieżka `npx eslint` nie została odpalona.
- README presetu uczciwie mówi, że wyników hooka nie wraca do czatu i że hook jest opcjonalny, gdy projekt już ma lint a11y.

---

## 3. Blockery (zanim ktokolwiek nazwie to „100%”)

### 3.1 Poziom A i AAA nie jest egzekwowany na warstwie, która zawsze wchodzi do kontekstu

README obiecuje: poziom A to wyłącznie kolumna A, AAA dochodzi po zmianie `wcag.config.json` albo w czacie.

Reguła (`wcag-2.2.mdc`) i sekcja „Key Rules” w skillu nakładają kryteria AA bez warunku poziomu. Warunek jest tylko dla standardu 2.1 vs 2.2 i dla „włącz AAA, gdy level = AAA”. Brakuje zdania: przy poziomie A nie stosuj kolumn AA i AAA.

Przy `level: "A"` agent i tak dostaje m.in.:

- kontrast 4.5:1 (1.4.3, AA);
- widoczny focus (2.4.7, AA);
- 24×24 CSS px (2.5.8, AA, i tylko dla 2.2);
- focus niezasłonięty (2.4.11, AA);
- dostępne logowanie (3.3.8, AA).

Przy `level: "AAA"` reguła ma jedno zdanie „zastosuj AAA” i nie wymienia 1.4.6 (7:1), 2.5.5 (44×44), 2.4.12, 2.4.13, 3.3.9. Te kryteria są w tabeli, ale tabela ładuje się tylko wtedy, gdy model ją otworzy.

Domyślne 2.2 AA przez to nie jest zepsute. Zepsuta jest obietnica przełącznika poziomu.

**Poprawka:** w regule i w skillu jawna macierz: dla ustalonego standardu i poziomu stosuj tylko kryteria z właściwych kolumn. Listy „zawsze” przenieść pod AA albo oznaczyć numerem i poziomem z warunkiem.

### 3.2 Hook w domyślnej instalacji nie domyka pętli i może zatrzymać agenta

`hooks.json` jest w katalogu, który README każe kopiować w całości. Hook więc jest włączony, chyba że ktoś doczyta akapit i go wytnie.

`afterFileEdit` w dokumentacji Cursora przyjmuje `file_path` i `edits`. Sekcja tego zdarzenia nie definiuje pól wyjścia. `afterTabFileEdit` ma wprost „no output fields”. `additional_context` jest na `postToolUse` / `sessionStart`, nie tutaj. Zwracane `{"continue":true}` nic nie wstrzykuje do rozmowy. Agent nie widzi wyników ESLint z tego skryptu. Osobne zdanie w README („the agent will see the lint errors”) dotyczy konfiguracji ESLint w projekcie, łatwo je czytać jako obietnicę hooka.

Skrypt i tak czeka na ESLint do 15 s (`spawnSync` timeout), a hook ma `timeout: 20`. To jest czas, przez który edycja agenta wisi, zanim model pójdzie dalej. Fail-open dotyczy awarii, nie opóźnienia.

Na Windowsie `shell: true` jest potrzebne, żeby znaleźć `npx.cmd`, i jednocześnie oddaje ścieżkę pliku do `cmd.exe`. Ścieżka ze spacją albo metaznakiem (`&`, `|`) psuje wywołanie albo uruchamia dodatkową komendę. Ścieżka pochodzi z edytora, ale do skryptu wpada jako string z JSON.

Inne dziury tej ścieżki:

- każda edycja agenta startuje Node, filtr rozszerzenia jest dopiero w skrypcie (matcher `afterFileEdit` umie tylko `Write`, więc tak musi być — koszt zostaje);
- brak ESLint w `package.json` jest obsłużony, ale każdy niezerowy kod ESLint (zły parser dla `.css` / `.vue`, brak flat config, crash) ląduje w logu jako „eslint findings”;
- log jest względny wobec cwd. Dokumentacja mówi, że hook projektowy startuje z roota repo. W monorepo ESLint często jest w paczce, a hook szuka `node_modules/eslint` i `package.json` w rootcie.

**Poprawka, jeśli hook zostaje:** nie uruchamiać ESLint synchronicznie na każdej edycji. Albo hook tylko dopisuje jednoznaczną linię do logu bez `npx`, albo wynik idzie zdarzeniem, które naprawdę wspiera `additional_context`. Na Windowsie `shell: false` i `npx.cmd` z cytowaną ścieżką. W logu rozdzielać exit code, brak configu i prawdziwe trafienia. W README instalacji: hook domyślnie wyłączony, dopóki ta pętla nie działa.

### 3.3 Wzorzec 2.4.11 nie realizuje kryterium, które opisuje

`references/code-patterns.md` i reguła sprowadzają 2.4.11 do `scroll-padding` / `scroll-margin`.

`scroll-padding` na `html` pomaga tylko wtedy, gdy przeglądarka przewija fokus do widoku. Nie odsłania elementu, który już jest w viewporcie i leży pod sticky headerem. `scroll-margin-top` na `main` nie dotyczy skupionych potomków `main`.

Agent, który skopiuje ten blok jako „fix 2.4.11”, odda kod, który kryterium nadal może oblać. To jest treść oznaczona w pliku jako production-ready.

**Poprawka:** napisać, że padding scrolla jest techniką wspomagającą i musi być równy realnej grubości sticky UI; osobno: fokus nie może startować pod tym UI. `scroll-margin` dać na skupialny element, nie na `main`.

### 3.4 Subagent „proactive” dubluje skill

Opisane w sekcji 1. Przy ocenie produkcji liczy się to jako zachowanie domyślne, nie jako kwestia gustu: reguła i description razem proszą o drugi przebieg po generowaniu UI.

---

## 4. Ważne, poniżej progu blokera dla domyślnego 2.2 AA

### Reguła i skill już się rozjeżdżają

Reguła jest jedyną warstwą gwarantowaną przy pliku z globu. Skill jest „refer to”, czyli model może go nie otworzyć.

| Temat | Reguła | Skill |
| --- | --- | --- |
| Duży tekst 3:1 (1.4.3) | brak, jest samo „≥ 4.5:1” | jest |
| Zakaz twierdzenia o zgodności | brak | jest, twardo |
| Wyjątki 2.5.8 poza inline | „spacing or inline” | pełna lista jest dopiero w `new-criteria.md` |
| 3.3.8 | „password manager i paste” | jest próg „cognitive function test” plus wyjątki |

„Password manager i paste” to mechanizm pomocniczy przy teście pamięci hasła. Formularz z paste i tak oblewa 3.3.8, gdy krok logowania wymaga łamigłówki (CAPTCHA) bez alternatywy. Reguła tego nie mówi.

Krok 3 skilla: „For WCAG 2.2, prioritize the 6 new A/AA criteria”. Przy audycie model nadważy te sześć kosztem pozostałych kryteriów AA (jest ich 55, nie 6). Kolejność pracy powinna być: cała kolumna wybranego poziomu, a nowe kryteria 2.2 jako delta przy migracji.

### `code-patterns.md`

- Skip link w przykładzie 2.4.1 nie ma stanu `:focus`. Typowa implementacja chowa go poza ekran i bez stylu fokusu link jest niespełnialny z klawiatury. Przykład tego nie pokazuje, więc model dopisze ukrycie sam.
- Spacing exception przy 2.5.8: `width/height: 20px` i `margin: 4px`. Okrąg 24 CSS px wystaje po 2 px poza boks 20 px. Pionowe marginesy bloków się zwijają, więc odstęp bywa 4 px, a okręgi się stykają. Komentarz „won't intersect” jest prawdziwy tylko przy odstępie, który się nie zwija, i tylko wobec drugiego takiego celu.
- `min-width/min-height: 24px` na `input[type=checkbox]` i `[role=button]` jest słabą realizacją celu wskaźnika. Cel to pole klikalne, nie minimalny rozmiar natywnej kontrolki po podmianie wyglądu.
- Sekcja „Focus Visible (2.4.7 + 2.4.13)” miesza AA (widoczny fokus) z AAA (2 CSS px i 3:1 między stanem focused i unfocused). Osobno, 1.4.11 (AA) też dotyczy stanu komponentu. Komentarz „for AAA” nie rozdziela tych dwóch podstaw.
- 3.3.7 pokazuje sam checkbox „same as shipping”, bez uzupełnionych pól. Jako szkic jest w porządku, jako wzorzec do wklejenia jest niekompletny.

### Pokrycie plików

Glob reguły: `html, tsx, jsx, vue, svelte, css, scss`. Poza nim zostają m.in. `.mdx` i `.astro`, czyli częste pliki UI. Hook ma ten sam zestaw co reguła, więc oba milczą na tych rozszerzeniach.

### PDF-y

`assets/WCAG_2.1.pdf` i `WCAG_2.2.pdf` to prawdziwe PDF-y (nagłówek `%PDF-1.4`, ok. 1,7 MB każdy). Skill każe ich nie czytać w całości. Model i tak często otwiera plik, który dostał jako „fallback”, i zapycha kontekst. Źródło robocze już jest w markdownie, a URL-e TR są w skillu. Do dystrybucji warto potwierdzić, że pliki są niezmienionymi kopiami W3C i że redystrybucja spełnia W3C Document License (nota prawna jest w samym PDF). Na jakość audytu te pliki nic nie dodają ponad tabele.

### Dwa wejścia do tej samej pracy

Rodzic przy pliku UI dostaje regułę, z niej prośbę o config, skill i subagenta. Opis skilla sam też pasuje do zadań a11y, więc skill może wejść drugi raz z discovery. Dla domyślnego AA to jest drogie, nie błędne. `paths` na skillu (oficjalne pole, glob plików UI) ograniczyłby podpowiadanie skilla przy plikach backendowych. Nie zastąpi reguły.

---

## 5. Drobne

- `new-criteria.md` pisze „the 6 … are marked below”, a wszystkie 9 są wypisane tak samo. Szóstka jest oznaczona tylko sufiksem poziomu. Lista szóstki jest czytelna w `wcag-2.1-vs-2.2.md`.
- Krótki opis 2.4.11 w tabeli („sticky header/footer”) węższy niż kryterium. Autor-created content obejmuje też inne nakładki.
- Root `README.md` w sekcji „Required Cursor Structure” pokazuje `hooks.json` jako część wymaganego układu. Presetowy README słusznie mówi, że hook jest opcjonalny. Dla kogoś, kto czyta tylko root, „wytnij hooka” wygląda jak zepsucie struktury.
- `.gitignore` repozytorium ma `.cursor/logs/`. To ignoruje logi odpalone w tym repo, nie w projekcie klienta. Instrukcja „dodaj `.cursor/logs/` do gitignore projektu” jest w README presetu i łatwo ją pominąć, bo domyślna instalacja to sam folder `.cursor/`.
- Brak testu automatycznego hooka. Ręczny smoke test fail-open przeszedł. Ścieżka z prawdziwym ESLint, ścieżka ze spacją w `file_path` i ścieżka monorepo nie były odpalone.
- Preset nie uruchamia axe, Lighthouse ani testu klawiatury. README to mówi i słusznie odsyła do eslint-plugin-jsx-a11y i axe w CI. To jest warunek zbliżenia się do zgodności. Sam preset jej nie dowodzi. Skill ma rację, że `pass` bez `path:line` albo wyniku narzędzia nie istnieje.

---

## 6. Werdykt operacyjny

| Pytanie | Odpowiedź |
| --- | --- |
| Czy kierunek „agent czyta skill” jest poprawny? | Tak. Skill jest procedurą, agent jest wykonawcą. Odwrotna zależność ucięłaby implementację, bo subagent jest readonly. |
| Czy subagent jest potrzebny? | Nie do pisania kodu. Tak, jeśli ma zostać osobnym, readonly audytem na żądanie. W obecnym opisie „proactively” jest zbędny i drogi. |
| Czy preset jest w 100% gotowy na produkcję? | Nie. |
| Czy domyślne 2.2 AA można dać zespołowi jako pomoc przy kodzie? | Tak, po obcięciu hooka albo po naprawie jego pętli, po poprawce wzorca 2.4.11 i po zdjęciu proactive z subagenta. Przełącznik A/AAA do tego czasu jest deklaracją, nie zachowaniem. |
| Czy wygenerowany UI będzie zgodny z WCAG? | Tego ten preset nie zapewnia i nie powinien tego obiecywać. |

### Kolejność poprawek

1. Macierz poziomu w regule i w skillu: A / AA / AAA naprawdę filtruje kryteria. Do reguły dopisać zakaz werdyktu „spełnia WCAG” i wyjątek dużego tekstu 3:1.
2. Albo hook wypiąć z domyślnej kopii, albo przestać wołać ESLint synchronicznie i oddać wynik kanałem, który agent czyta. Na Windowsie bez `shell: true` na surowej ścieżce.
3. Przepisać wzorzec 2.4.11 tak, żeby `scroll-margin` na `main` nie wyglądał jak spełnienie kryterium.
4. Zostawić `a11y-reviewer` jako `/a11y-reviewer` i audyt na prośbę. Usunąć „use proactively” oraz automatyczną delegację z reguły.
5. W kroku workflow skilla: pełna kolumna poziomu, a sześć nowych kryteriów A/AA tylko jako priorytet migracji 2.1 → 2.2.
