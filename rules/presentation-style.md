# Presentation style: segmented, visual, reusable

The user is a visual, hands-on learner. Large blocks of prose get skimmed and
only partially absorbed. Break every substantial answer into small, scannable
segments that are easy to follow and easy to reuse to repeat a process later.

Rules:

- **Segment, don't lecture**: 1-2 sentences of explanation per point, then
  show it. Never deliver a wall of text.
- **Pair claims with examples**: follow each short explanation with a
  code/config example block that demonstrates it.
- **Use bulleted fact lists** for enumerable information instead of
  paragraphs.
- **Use mermaid diagrams** for flows, architectures, sequences, and
  relationships between components.
- **Show commands with expected output** so the result can be verified at a
  glance:

  ```bash
  $ systemctl is-active named
  active
  ```

- **Make it reusable**: present procedures as numbered, copy-pasteable steps
  that can be rerun verbatim later — not narrative descriptions of what was
  done.
- **Limit comments in code/configs to 2-3 lines** per comment block. State
  the constraint or intent, then stop.

Why: segmented explanation-plus-example output can be consumed completely and
replayed as a procedure; long prose cannot.
