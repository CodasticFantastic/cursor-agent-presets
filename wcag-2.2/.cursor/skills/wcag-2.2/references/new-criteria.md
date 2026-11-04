# New Success Criteria in WCAG 2.2

WCAG 2.2 adds 9 Success Criteria and removes 4.1.1 Parsing (now obsolete).
Six are inside Level AA conformance (the criterion's own level is A or AA). Each heading below is marked **[in AA conformance]** or **[AAA only]**.
The six are 2.4.11, 2.5.7, 2.5.8, 3.2.6, 3.3.7, and 3.3.8. The AAA-only criteria are 2.4.12, 2.4.13, and 3.3.9.
The text below paraphrases the W3C Recommendation. It is not a full copy of the normative wording. The recommendation is https://www.w3.org/TR/WCAG22/.

## 2.4.11 Focus Not Obscured (Minimum) — AA — [in AA conformance]

When a user interface component receives keyboard focus, the component is not entirely hidden due to author-created content.

**Notes:**
- Only initial positions of user-movable content are considered.
- User-opened content may obscure focus if the user can reveal the focused component without advancing keyboard focus.

**Implementation:** `scroll-padding` on the scroll container applies when the browser scrolls focus into view. Size it from the real sticky-bar thickness. Put `scroll-margin` on the focused control, not on `main`. Neither declaration satisfies 2.4.11 when the control is already on screen and fully covered. See `references/code-patterns.md`. Prefer modal dialogs that take focus. A non-modal overlay must not fully cover the focused component.

**Audit notes:** When fixed/sticky CSS gives sizes and offsets (e.g. cookie bar height + FAB `bottom`), compute overlap in source and file as **code** if the focused control’s box is entirely under author chrome. Partial cover of another control is AA-OK for 2.4.11 (AAA 2.4.12 is stricter).

## 2.4.12 Focus Not Obscured (Enhanced) — AAA — [AAA only]

When a user interface component receives keyboard focus, no part of the component is hidden by author-created content.

## 2.4.13 Focus Appearance — AAA — [AAA only]

When the keyboard focus indicator is visible, an area of the focus indicator meets all of the following:
- is at least as large as the area of a 2 CSS pixel thick perimeter of the unfocused component or sub-component, and
- has a contrast ratio of at least 3:1 between the same pixels in the focused and unfocused states.

Exceptions: user-agent determined, or author does not modify the indicator/background.

## 2.5.7 Dragging Movements — AA — [in AA conformance]

All functionality that uses a dragging movement for operation can be achieved by a single pointer without dragging, unless dragging is essential or the functionality is determined by the user agent and not modified by the author.

**Examples of alternatives:** buttons to move/resize, click-to-select then click-to-place, native range inputs, keyboard alternatives.

## 2.5.8 Target Size (Minimum) — AA — [in AA conformance]

The size of the target for pointer inputs is at least 24 by 24 CSS pixels, except when:

- **Spacing**: Undersized targets are spaced so that a 24 CSS pixel diameter circle centered on each does not intersect another target.
- **Equivalent**: Function available via another control on the same page that meets the criterion.
- **Inline**: Target is in a sentence or constrained by line-height of non-target text.
- **User Agent Control**: Size determined by UA and not modified by author.
- **Essential**: Particular presentation is essential or legally required.

**Audit notes:** Check **Equivalent** before failing a 16×16 icon that has a labeled 24×24+ twin. Spacing can pass AA 2.5.8 and still fail AAA 2.5.5 (no spacing exception there). Inline sentence links are not 24×24 requirements.

## 3.2.6 Consistent Help — A — [in AA conformance]

If a web page contains any of the following help mechanisms, and those mechanisms are repeated on multiple web pages within a set of web pages, they occur in the same order relative to other page content, unless a change is initiated by the user:
- Human contact details
- Human contact mechanism
- Self-help option
- A fully automated contact mechanism

**Audit notes:** Fail when the **relative order** of help mechanisms changes (e.g. chat moves before phone; Contact and FAQ swap). Do **not** fail a page that simply omits some mechanisms (subset) while keeping the remaining ones in the same relative order. See `judgment-traps.md`.

## 3.3.7 Redundant Entry — A — [in AA conformance]

Information previously entered by or provided to the user that is required to be entered again in the same process is either:
- auto-populated, or
- available for the user to select.

Exceptions: re-entry is essential, required for security, or previously entered information is no longer valid.

**Audit notes:** “Confirm password” usually fits the security exception. “Confirm email” (or re-typing a mailing address already stored in the same process) usually does **not** — file 3.3.7. Empty “new address” fields after the user marks the old address invalid are the “no longer valid” exception.

## 3.3.8 Accessible Authentication (Minimum) — AA — [in AA conformance]

A cognitive function test (such as remembering a password or solving a puzzle) is not required for any step in an authentication process unless that step provides at least one of the following:
- **Alternative**: Another authentication method that does not rely on a cognitive function test.
- **Mechanism**: A mechanism is available to assist the user in completing the cognitive function test.
- **Object Recognition**: The cognitive function test is to recognize objects.
- **Personal Content**: The cognitive function test is to identify non-text content the user provided to the website.

**Notes:** Mechanisms include support for password managers and copy/paste.

**Audit notes:**
- Character / transcription CAPTCHA (type the distorted characters) is a cognitive function test — **fails** 3.3.8 without an alternative. Also check 1.1.1 for a non-visual CAPTCHA alternative.
- Recognizing objects in images (pick all kayaks) fits **Object Recognition** at AA — do **not** fail 3.3.8 for that alone. Still file 1.1.1 if tiles lack a usable non-visual alternative. At AAA, object recognition is **not** enough — see 3.3.9.
- Blocking paste on a recovery word / password step removes the Mechanism path — fail 3.3.8.

## 3.3.9 Accessible Authentication (Enhanced) — AAA — [AAA only]

A cognitive function test is not required for any step in an authentication process unless that step provides at least one of the following:
- Alternative
- Mechanism

(Stricter than 3.3.8 — fewer exceptions. Object recognition and personal content do **not** exempt at AAA.)

---

**Removed:** 4.1.1 Parsing is obsolete and removed from WCAG 2.2. Modern browsers and assistive technologies handle markup errors sufficiently. Do not treat parsing errors as a WCAG 2.2 failure.
