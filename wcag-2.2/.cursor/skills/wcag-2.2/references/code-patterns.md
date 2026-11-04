# Code Patterns for WCAG 2.2

Patterns for criteria that are in scope. Prefer semantic HTML. A pattern is a starting point. Copying it is not a conformance claim.

## Focus Not Obscured (2.4.11, AA)

The focused component must not be entirely hidden by author-created content: a sticky header or footer, a banner, or another overlay. User-opened content can cover focus when the user can reveal the component without moving keyboard focus.

`scroll-padding` on the scroll container applies only when the browser scrolls the focused element into view. Set it from the sticky bar's real thickness, not from a fixed guess.

It does not uncover a control that is already on screen and sitting under the bar. `scroll-margin` goes on the focused control. `scroll-margin` on `main` does not apply to those descendants and does not satisfy 2.4.11.

```css
:root {
  --sticky-header-height: 4rem; /* the real header, plus a small buffer */
  --sticky-footer-height: 3rem;
}

html {
  scroll-padding-top: var(--sticky-header-height);
  scroll-padding-bottom: var(--sticky-footer-height);
}

a:focus,
button:focus,
input:focus,
select:focus,
textarea:focus,
[tabindex]:focus {
  scroll-margin-top: var(--sticky-header-height);
  scroll-margin-bottom: var(--sticky-footer-height);
}
```

If the focused control still sits fully under the bar without a scroll, change the layout: shorten the bar, inset the content, or move the target. Treat 2.4.11 as hybrid until the rendered page shows the focused component clear of author-created content. At AAA, 2.4.12 allows no part of the component to be hidden.

## Target Size (2.5.8, AA)

The target is the pointer hit area, including padding. `min-width` on a native checkbox, radio, or a `[role=button]` that is drawn smaller than its box does not create that hit area.

Inline exception: a target in a sentence, or one constrained by the line-height of surrounding text, is exempt. A text link is `display: inline` by default. Do not force 24×24 CSS px on it.

Other exceptions: an equivalent control on the same page that meets 24×24; spacing (below); size left to the user agent and not modified by the author; a presentation that is essential.

```css
/* Controls and control-like links. Not inline text links. */
button,
a.button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
  min-width: 24px;
  min-height: 24px;
  padding: 4px;
}
```

Spacing exception: center a 24 CSS px circle on each undersized target. The circles must not intersect another target. A 20px box extends 2px past each edge, so the gap between border boxes must be greater than 4px. Use `gap`. Vertical margins collapse and can eat the spacing.

```css
.icon-toolbar {
  display: flex;
  gap: 8px;
}

.icon-toolbar .icon-button {
  box-sizing: border-box;
  width: 20px;
  height: 20px;
  padding: 0;
}
```

At AAA, 2.5.5 asks for 44×44 CSS px. Do not apply 2.5.5 at A or AA.

## Dragging Movements Alternative (2.5.7, AA)

```html
<!-- Native range: do not add aria-value*. Use those attributes only on a custom role="slider". -->
<label for="volume">Volume</label>
<input type="range" id="volume" name="volume" min="0" max="100" value="50" />

<!-- For custom drag: provide buttons -->
<div class="sortable-list">
  <button type="button" aria-label="Move item up">↑</button>
  <button type="button" aria-label="Move item down">↓</button>
</div>
```

Dragging that is essential is an exception. The source usually cannot prove that. Class it as manual.

## Accessible Authentication (3.3.8, AA)

Password managers and paste are a mechanism for the "remember a password" step. They do not cover a puzzle or CAPTCHA. That step still needs one of: another method that is not a cognitive test, a mechanism that assists it, object recognition, or non-text personal content the user provided to the site.

```html
<form autocomplete="on">
  <label for="email">Email</label>
  <input
    type="email"
    id="email"
    name="email"
    autocomplete="username"
    required
  />

  <label for="password">Password</label>
  <input
    type="password"
    id="password"
    name="password"
    autocomplete="current-password"
    required
  />
  <!-- Leave paste and password-manager autofill enabled. -->
</form>
```

Do not add a puzzle here and treat the form as meeting 3.3.8. At AAA, 3.3.9 drops the object-recognition and personal-content exceptions.

## Redundant Entry (3.3.7, A)

Data already provided in the same process is prefilled or available to select. A checkbox alone, with empty billing fields, does not meet the criterion.

```html
<fieldset>
  <legend>Shipping address</legend>
  <label for="ship-street">Street</label>
  <input id="ship-street" name="ship-street" autocomplete="shipping street-address" value="1 Example Road" />
</fieldset>

<fieldset>
  <legend>Billing address</legend>
  <label>
    <input type="checkbox" name="billing-same" checked />
    Same as shipping address
  </label>
  <label for="bill-street">Street</label>
  <input id="bill-street" name="bill-street" autocomplete="billing street-address" value="1 Example Road" />
</fieldset>
```

Re-entry that is essential, required for security, or no longer valid is an exception.

## Consistent Help (3.2.6, A)

When human contact, a contact mechanism, self-help, or an automated contact mechanism repeats across pages, keep those mechanisms in the same relative order. One page cannot show this. Compare the pages in scope.

## Focus Visible (2.4.7, AA) and related contrast

2.4.7, AA in both 2.1 and 2.2: the keyboard focus indicator is visible. This example is a visible ring.

1.4.11, AA: when that ring is how the user identifies the focused state, it needs 3:1 against the adjacent color.

2.4.13, AAA only: the indicator's area is at least a 2 CSS px perimeter, and the same pixels change by at least 3:1 between the focused and unfocused states. Do not require 2.4.13 at A or AA.

```css
:focus-visible {
  outline: 2px solid #005fcc;
  outline-offset: 2px;
}
```

Check the rendered colors before calling 1.4.11 a pass. `#005fcc` on white is a candidate, not evidence.

## Semantic Structure + Landmarks (1.3.1 A, 2.4.1 A)

A skip link that is moved off-screen needs a visible `:focus` state. Hiding it with no focus style fails 2.4.1 for keyboard users.

```html
<html lang="en">
  <body>
    <a href="#main" class="skip-link">Skip to main content</a>
    <header>...</header>
    <nav aria-label="Main">...</nav>
    <main id="main">...</main>
    <footer>...</footer>
  </body>
</html>
```

```css
.skip-link {
  position: absolute;
  left: 0;
  top: 0;
  transform: translateY(-100%);
  padding: 0.5rem 1rem;
  background: #fff;
  color: #111;
  z-index: 1000;
}

.skip-link:focus {
  transform: none;
}
```

## Form Labels & Autocomplete (1.3.5 AA, 3.3.2 A)

```html
<label for="name">Full name</label>
<input type="text" id="name" name="name" autocomplete="name" required />

<label for="cc-number">Card number</label>
<input type="text" id="cc-number" name="cc-number" autocomplete="cc-number" inputmode="numeric" />
```

1.3.5 is AA. At level A, labels (3.3.2) still apply and autocomplete does not.

## Status Messages (4.1.3, AA)

`role="status"` already implies `aria-live="polite"`. The live region should be present before the message text is inserted.

```html
<div role="status">
  Form submitted successfully.
</div>
```

## Non-text Contrast and Color (1.4.1 A, 1.4.11 AA)

Do not use color as the only visual means (1.4.1, A). At AA, UI components and meaningful graphics need 3:1 against adjacent colors (1.4.11). At AAA, text contrast is 1.4.6 (7:1 normal, 4.5:1 large), not 1.4.3.
