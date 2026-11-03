# WCAG 2.1 – Success Criteria Table (A / AA / AAA)

Complete, readable table for the AI agent.  
**WCAG 2.1** = 78 criteria (30 A / 20 AA / 28 AAA). Level AA is 50 criteria (all A + all AA).

**Conformance levels (important):**
- **Level A** = only criteria marked ✔️ in column A (minimum).
- **Level AA** = all A + all AA (✔️ in A or AA columns). This is the default level when the user asks for WCAG 2.1 without a level (50 criteria).
- **Level AAA** = all A + all AA + all AAA (✔️ in any column). Strictest level — rarely required for whole sites, often used for specific high-stakes content.

**Legend:**  
✔️ – required at this level

This table is WCAG 2.1 only. It does not include the 9 criteria added in WCAG 2.2. For those, and for 4.1.1 removed in 2.2, load `references/wcag-2.1-vs-2.2.md`.

When auditing, always check the column that matches the requested level (default = AA).

| Criterion | Name | A | AA | AAA | Short description (for agent) |
|-----------|------|---|----|-----|-------------------------------|
| **1.1.1** | Non-text Content | ✔️ | | | Text alternative for images, icons, charts |
| **1.2.1** | Audio-only or Video-only (Prerecorded) | ✔️ | | | Text alternative |
| **1.2.2** | Captions (Prerecorded) | ✔️ | | | Captions for prerecorded video |
| **1.2.3** | Audio Description or Media Alternative (Prerecorded) | ✔️ | | | Audio description or full alternative |
| **1.2.4** | Captions (Live) | | ✔️ | | Captions for live video |
| **1.2.5** | Audio Description (Prerecorded) | | ✔️ | | Audio description for prerecorded video |
| **1.2.6** | Sign Language (Prerecorded) | | | ✔️ | Sign language interpretation |
| **1.2.7** | Extended Audio Description (Prerecorded) | | | ✔️ | Extended audio description |
| **1.2.8** | Media Alternative (Prerecorded) | | | ✔️ | Full text alternative for media |
| **1.2.9** | Audio-only (Live) | | | ✔️ | Text alternative for live audio |
| **1.3.1** | Info and Relationships | ✔️ | | | Semantic structure (headings, lists, tables, labels) |
| **1.3.2** | Meaningful Sequence | ✔️ | | | Code order matches reading order |
| **1.3.3** | Sensory Characteristics | ✔️ | | | Instructions not solely visual/audio |
| **1.3.4** | Orientation | | ✔️ | | Works in portrait and landscape |
| **1.3.5** | Identify Input Purpose | | ✔️ | | Autocomplete attributes |
| **1.3.6** | Identify Purpose | | | ✔️ | Purpose of UI components (ARIA) |
| **1.4.1** | Use of Color | ✔️ | | | Color not the only visual means |
| **1.4.2** | Audio Control | ✔️ | | | Ability to stop auto-playing audio > 3s |
| **1.4.3** | Contrast (Minimum) | | ✔️ | | 4.5:1 normal text, 3:1 large text |
| **1.4.4** | Resize Text | | ✔️ | | Text resizable to 200% without loss |
| **1.4.5** | Images of Text | | ✔️ | | Prefer real text |
| **1.4.6** | Contrast (Enhanced) | | | ✔️ | 7:1 / 4.5:1 |
| **1.4.7** | Low or No Background Audio | | | ✔️ | Clean speech audio |
| **1.4.8** | Visual Presentation | | | ✔️ | User can control spacing, width, etc. |
| **1.4.9** | Images of Text (No Exception) | | | ✔️ | No images of text |
| **1.4.10** | Reflow | | ✔️ | | No horizontal scroll at 320px |
| **1.4.11** | Non-text Contrast | | ✔️ | | Min. 3:1 for UI components and graphics |
| **1.4.12** | Text Spacing | | ✔️ | | Works with increased spacing |
| **1.4.13** | Content on Hover or Focus | | ✔️ | | Dismissible, hoverable, persistent |
| **2.1.1** | Keyboard | ✔️ | | | All functionality available from keyboard |
| **2.1.2** | No Keyboard Trap | ✔️ | | | Can exit every element with keyboard |
| **2.1.3** | Keyboard (No Exception) | | | ✔️ | Everything keyboard-accessible without exceptions |
| **2.1.4** | Character Key Shortcuts | ✔️ | | | Ability to turn off/remap |
| **2.2.1** | Timing Adjustable | ✔️ | | | Ability to extend/turn off time limits |
| **2.2.2** | Pause, Stop, Hide | ✔️ | | | Control over animations/carousels |
| **2.2.3** | No Timing | | | ✔️ | No time limits |
| **2.2.4** | Interruptions | | | ✔️ | Ability to postpone interruptions |
| **2.2.5** | Re-authenticating | | | ✔️ | Preserve data after timeout |
| **2.2.6** | Timeouts | | | ✔️ | Warning about timeout |
| **2.3.1** | Three Flashes or Below Threshold | ✔️ | | | Max 3 flashes per second |
| **2.3.2** | Three Flashes | | | ✔️ | No flashes |
| **2.3.3** | Animation from Interactions | | | ✔️ | Ability to disable animations |
| **2.4.1** | Bypass Blocks | ✔️ | | | Skip link / landmarks |
| **2.4.2** | Page Titled | ✔️ | | | Descriptive `<title>` |
| **2.4.3** | Focus Order | ✔️ | | | Logical Tab order |
| **2.4.4** | Link Purpose (In Context) | ✔️ | | | Link purpose clear from context |
| **2.4.5** | Multiple Ways | | ✔️ | | More than one way to locate pages |
| **2.4.6** | Headings and Labels | | ✔️ | | Descriptive headings and labels |
| **2.4.7** | Focus Visible | | ✔️ | | Visible focus indicator |
| **2.4.8** | Location | | | ✔️ | Information about location in site |
| **2.4.9** | Link Purpose (Link Only) | | | ✔️ | Purpose clear from link text alone |
| **2.4.10** | Section Headings | | | ✔️ | Sections have headings |
| **2.5.1** | Pointer Gestures | ✔️ | | | Single-pointer alternative for complex gestures |
| **2.5.2** | Pointer Cancellation | ✔️ | | | Ability to cancel pointer action |
| **2.5.3** | Label in Name | ✔️ | | | Accessible name contains visible label |
| **2.5.4** | Motion Actuation | ✔️ | | | Alternative for motion-triggered functions |
| **2.5.5** | Target Size (Enhanced) | | | ✔️ | Min. 44×44 CSS px |
| **2.5.6** | Concurrent Input Mechanisms | | | ✔️ | Do not restrict input methods |
| **3.1.1** | Language of Page | ✔️ | | | `lang` on `<html>` |
| **3.1.2** | Language of Parts | | ✔️ | | Language changes marked |
| **3.1.3** | Unusual Words | | | ✔️ | Explanations of difficult words |
| **3.1.4** | Abbreviations | | | ✔️ | Explanations of abbreviations |
| **3.1.5** | Reading Level | | | ✔️ | Text understandable (approx. lower secondary) |
| **3.1.6** | Pronunciation | | | ✔️ | Pronunciation explanations |
| **3.2.1** | On Focus | ✔️ | | | Focus does not change context |
| **3.2.2** | On Input | ✔️ | | | Input does not unexpectedly change context |
| **3.2.3** | Consistent Navigation | | ✔️ | | Consistent navigation order |
| **3.2.4** | Consistent Identification | | ✔️ | | Consistent identification of functions |
| **3.2.5** | Change on Request | | | ✔️ | Changes only on request |
| **3.3.1** | Error Identification | ✔️ | | | Errors described in text |
| **3.3.2** | Labels or Instructions | ✔️ | | | Labels and instructions for inputs |
| **3.3.3** | Error Suggestion | | ✔️ | | Suggestions for fixing errors |
| **3.3.4** | Error Prevention (Legal, Financial, Data) | | ✔️ | | Confirmation / reversible |
| **3.3.5** | Help | | | ✔️ | Contextual help |
| **3.3.6** | Error Prevention (All) | | | ✔️ | Error prevention in all forms |
| **4.1.1** | Parsing | ✔️ | | | Complete tags, valid nesting, no duplicate attributes, unique ids. Removed in WCAG 2.2 as obsolete. |
| **4.1.2** | Name, Role, Value | ✔️ | | | Name, role, value/state programmatically determinable |
| **4.1.3** | Status Messages | | ✔️ | | Status messages available to AT (without focus) |

---

**Source:** Official WCAG 2.1 Recommendation (https://www.w3.org/TR/WCAG21/).  
Fallback PDF: `assets/WCAG_2.1.pdf`. Open it only when this table does not answer the question. Do not load the whole PDF into context.
