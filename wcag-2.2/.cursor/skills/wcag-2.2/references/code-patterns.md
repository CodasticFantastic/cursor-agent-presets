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

`min-width` and `min-height` do not apply to a non-replaced inline element. A text link is `display: inline` by default, and 2.5.8 exempts a target that sits in a sentence or is constrained by the line-height of non-target text (Inline exception). Do not force 24×24 CSS pixels on those links.

```css
/* Controls. Not text links inside a sentence. */
button,
input[type="checkbox"],
input[type="radio"],
[role="button"] {
  min-width: 24px;
  min-height: 24px;
}

/* Link used as a control. inline-flex makes the minimum size apply. */
a.button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
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
<!-- Prefer native range over a custom drag slider.
     ARIA in HTML: the browser exposes min, max, and value as the slider
     aria-valuemin, aria-valuemax, and aria-valuenow.
     Authors SHOULD NOT set aria-valuemin or aria-valuemax on input type=range,
     and MUST NOT set them when min or max is also present.
     Set aria-valuemin, aria-valuemax, and aria-valuenow only on a custom
     role="slider" that has no native min, max, or value. -->
<label for="volume">Volume</label>
<input type="range" id="volume" min="0" max="100" value="50" />

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

On a multi-page app, put the same skip + matching `id` on **every** route in the set (or in a shared layout). A skip on home alone does not satisfy 2.4.1 elsewhere. Prefer the layout so individual pages cannot omit the target.

## Layout tables vs data tables (1.3.1)

```html
<!-- Layout only — hide table semantics -->
<table role="presentation">
  <tr>
    <td>Hours</td>
    <td>09:00–17:00</td>
  </tr>
</table>

<!-- Real data — keep table semantics + headers -->
<table>
  <caption>Order summary</caption>
  <thead>
    <tr><th scope="col">Item</th><th scope="col">Qty</th></tr>
  </thead>
  <tbody>...</tbody>
</table>
```

Do not use a bare `<table>` for CSS grid/columns without `role="presentation"`. Do not mark a real data table as presentation.

## ARIA name references (4.1.2)

```html
<!-- Broken: id does not exist → empty/wrong accessible name -->
<section aria-labelledby="missing-promo-label">...</section>

<!-- OK: referenced id exists -->
<h2 id="promo-label">Spring sale</h2>
<section aria-labelledby="promo-label">...</section>
```

Never leave focusable controls (`a`, `button`, inputs, `tabIndex={0}`) inside `aria-hidden="true"`. Hide from AT only when the subtree is also removed from the tab order.

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