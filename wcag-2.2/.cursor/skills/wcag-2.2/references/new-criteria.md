# New Success Criteria in WCAG 2.2

WCAG 2.2 adds 9 Success Criteria and removes 4.1.1 Parsing (now obsolete).  
The 6 that affect Level AA conformance are marked below. Normative text extracted from the official W3C Recommendation.

## 2.4.11 Focus Not Obscured (Minimum) — AA

When a user interface component receives keyboard focus, the component is not entirely hidden due to author-created content.

**Notes:**
- Only initial positions of user-movable content are considered.
- User-opened content may obscure focus if the user can reveal the focused component without advancing keyboard focus.

**Implementation:** Use `scroll-padding-top` / `scroll-padding-bottom` for sticky headers/footers. Prefer modal dialogs that take focus. Avoid non-modal overlays that fully cover focused elements.

## 2.4.12 Focus Not Obscured (Enhanced) — AAA

When a user interface component receives keyboard focus, no part of the component is hidden by author-created content.

## 2.4.13 Focus Appearance — AAA

When the keyboard focus indicator is visible, an area of the focus indicator meets all of the following:
- is at least as large as the area of a 2 CSS pixel thick perimeter of the unfocused component or sub-component, and
- has a contrast ratio of at least 3:1 between the same pixels in the focused and unfocused states.

Exceptions: user-agent determined, or author does not modify the indicator/background.

## 2.5.7 Dragging Movements — AA

All functionality that uses a dragging movement for operation can be achieved by a single pointer without dragging, unless dragging is essential or the functionality is determined by the user agent and not modified by the author.

**Examples of alternatives:** buttons to move/resize, click-to-select then click-to-place, native range inputs, keyboard alternatives.

## 2.5.8 Target Size (Minimum) — AA

The size of the target for pointer inputs is at least 24 by 24 CSS pixels, except when:

- **Spacing**: Undersized targets are spaced so that a 24 CSS pixel diameter circle centered on each does not intersect another target.
- **Equivalent**: Function available via another control on the same page that meets the criterion.
- **Inline**: Target is in a sentence or constrained by line-height of non-target text.
- **User Agent Control**: Size determined by UA and not modified by author.
- **Essential**: Particular presentation is essential or legally required.

## 3.2.6 Consistent Help — A

If a web page contains any of the following help mechanisms, and those mechanisms are repeated on multiple web pages within a set of web pages, they occur in the same order relative to other page content, unless a change is initiated by the user:
- Human contact details
- Human contact mechanism
- Self-help option
- A fully automated contact mechanism

## 3.3.7 Redundant Entry — A

Information previously entered by or provided to the user that is required to be entered again in the same process is either:
- auto-populated, or
- available for the user to select.

Exceptions: re-entry is essential, required for security, or previously entered information is no longer valid.

## 3.3.8 Accessible Authentication (Minimum) — AA

A cognitive function test (such as remembering a password or solving a puzzle) is not required for any step in an authentication process unless that step provides at least one of the following:
- **Alternative**: Another authentication method that does not rely on a cognitive function test.
- **Mechanism**: A mechanism is available to assist the user in completing the cognitive function test.
- **Object Recognition**: The cognitive function test is to recognize objects.
- **Personal Content**: The cognitive function test is to identify non-text content the user provided to the website.

**Notes:** Mechanisms include support for password managers and copy/paste.

## 3.3.9 Accessible Authentication (Enhanced) — AAA

A cognitive function test is not required for any step in an authentication process unless that step provides at least one of the following:
- Alternative
- Mechanism

(Stricter than 3.3.8 — fewer exceptions.)

---

**Removed:** 4.1.1 Parsing is obsolete and removed from WCAG 2.2. Modern browsers and assistive technologies handle markup errors sufficiently. Do not treat parsing errors as a WCAG 2.2 failure.
