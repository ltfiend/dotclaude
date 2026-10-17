# Log output to output.md always, do not commit to git repos

Rules:

- **Log output to output-log.md**: All claude session output, exactly as 
  displayed, record it.
- **Never commit output-log.md**: Add it to the .gitignore, make sure it never
  appears in a git repository.

Why: user wants a historical record to reference in the event the session gets
closed or lost.
