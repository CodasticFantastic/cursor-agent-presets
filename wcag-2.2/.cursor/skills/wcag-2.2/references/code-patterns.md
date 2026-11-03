# Code Patterns for WCAG 2.2

Practical, production-ready patterns. Prefer semantic HTML.

## Focus Not Obscured (2.4.11) — Sticky Header/Footer

```css
/* Ensure focused elements are not fully hidden under sticky UI */
html {
  scroll-padding-top: 5rem;    /* height of sticky header + buffer */
  scroll-padding-bottom: 4rem; /* height of sticky footer + buffer */
}

/* Alternative for specific containers */
main {
  scroll-margin-top: 5rem;
}
```

## Target Size (2.5.8)

```css
/* Minimum target size */
button,
a,
input[type="checkbox"],
input[type="radio"],
[role="button"] {
  min-width: 24px;
  min-height: 24px;
}

/* Spacing exception for smaller targets */
.icon-button {
  width: 20px;
  height: 20px;
  margin: 4px; /* 24px circles won't intersect */
}
```

## Dragging Movements Alternative (2.5.7)

```html
<!-- Prefer native range over custom drag slider -->
<label for="volume">Volume</label>
<input
  type="range"
  id="volume"
  min="0"
  max="100"
  value="50"
  aria-valuemin="0"
  aria-valuemax="100"
  aria-valuenow="50"
/>

<!-- For custom drag: provide buttons -->
<div class="sortable-list">
  <button type="button" aria-label="Move item up">↑</button>
  <button type="button" aria-label="Move item down">↓</button>
</div>
```

## Accessible Authentication (3.3.8)

```html
<!-- Support password managers + paste -->
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
  <!-- Do not disable paste or password manager autofill -->
</form>
```

## Redundant Entry (3.3.7)

```html
<fieldset>
  <legend>Billing Address</legend>
  <label>
    <input type="checkbox" id="same-as-shipping" checked />
    Same as shipping address
  </label>
  <!-- Fields pre-filled or hidden when checked -->
</fieldset>
```

## Consistent Help (3.2.6)

Place help mechanisms (contact, chat, FAQ, phone) in the same relative order across pages, typically in the header or footer.

## Focus Visible (2.4.7 + 2.4.13 considerations)

```css
:focus-visible {
  outline: 2px solid #005fcc;
  outline-offset: 2px;
}

/* Ensure contrast ≥ 3:1 between focused and unfocused states for AAA */
```

## Semantic Structure + Landmarks (1.3.1, 2.4.1)

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

## Form Labels & Autocomplete (1.3.5, 3.3.2)

```html
<label for="name">Full name</label>
<input type="text" id="name" name="name" autocomplete="name" required />

<label for="cc-number">Card number</label>
<input type="text" id="cc-number" autocomplete="cc-number" inputmode="numeric" />
```

## Status Messages (4.1.3)

```html
<div role="status" aria-live="polite">
  Form submitted successfully.
</div>
```

## Non-text Contrast & Color (1.4.1, 1.4.11)

Never rely on color alone. Ensure UI components (borders, icons, focus rings) meet 3:1 contrast.