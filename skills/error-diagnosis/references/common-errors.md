# Common Errors Reference

Catalog of frequently encountered errors and their solutions.

## Bash Tool Errors

### Command Not Found

**Error:** `bash: [command]: command not found`

**Causes:**
- Tool not installed
- Not in PATH
- Typo in command name

**Solutions:**
- Check installation: `which [command]` or `command -v [command]`
- Install if missing
- Use full path if PATH issue

**Prevention:** Check command availability before complex scripts

---

### Permission Denied

**Error:** `bash: [file]: Permission denied`

**Causes:**
- File not executable
- Insufficient permissions
- Protected directory

**Solutions:**
- Make executable: `chmod +x [file]`
- Check permissions: `ls -la [file]`
- Use sudo if appropriate (with user approval)

**Prevention:** Verify permissions before execution

---

### File Not Found

**Error:** `[file]: No such file or directory`

**Causes:**
- Typo in path
- File doesn't exist yet
- Wrong working directory

**Solutions:**
- Verify path: `ls [directory]`
- Check current directory: `pwd`
- Use absolute paths

**Prevention:** Always verify paths exist before operations

---

## Write/Edit Tool Errors

### File Already Exists (Write)

**Error:** Cannot overwrite without reading first

**Cause:** Attempting to write to existing file without reading

**Solution:** Read file first, then write or use Edit instead

**Prevention:** Check if file exists before Write operations

---

### String Not Found (Edit)

**Error:** `old_string` not found in file

**Causes:**
- Whitespace mismatch
- String was already changed
- Wrong file

**Solutions:**
- Re-read the file to get exact content
- Check for invisible characters
- Verify correct file path

**Prevention:** Always read file immediately before editing

---

### Non-unique Match (Edit)

**Error:** Multiple matches for `old_string`

**Cause:** String appears multiple times in file

**Solutions:**
- Include more context in old_string
- Use `replace_all: true` if all should change
- Make string more specific

**Prevention:** Include surrounding lines for unique identification

---

## Read Tool Errors

### File Too Large

**Error:** File exceeds size limit

**Cause:** Attempting to read very large file

**Solutions:**
- Use `limit` and `offset` parameters
- Read specific sections
- Use Grep to find relevant parts first

**Prevention:** Check file size with `ls -lh` before reading large files

---

### Binary File

**Error:** Cannot read binary file

**Cause:** Attempting to read non-text file

**Solutions:**
- Use appropriate tool (Read for images)
- Use `file [path]` to check type
- Use hex dump if needed: `xxd [file] | head`

**Prevention:** Verify file type before reading

---

## Glob Tool Errors

### No Matches

**Error:** No files matching pattern

**Causes:**
- Wrong pattern syntax
- Files don't exist
- Wrong directory

**Solutions:**
- Simplify pattern
- Check directory contents
- Verify path is correct

**Prevention:** Start with broad patterns, narrow down

---

## Grep Tool Errors

### Pattern Syntax Error

**Error:** Invalid regex pattern

**Cause:** Unescaped special characters

**Solutions:**
- Escape special chars: `\{`, `\}`, `\[`, `\]`
- Use `-F` for literal strings (in bash grep)
- Test pattern on simple content first

**Prevention:** Escape braces and brackets in patterns

---

### No Results

**Error:** Empty results when expecting matches

**Causes:**
- Case sensitivity
- Wrong file type filter
- Pattern too specific

**Solutions:**
- Add `-i` for case insensitive
- Check `glob` and `type` parameters
- Broaden pattern

**Prevention:** Start broad, then narrow

---

## Task/Agent Errors

### Agent Timeout

**Error:** Agent exceeded time limit

**Causes:**
- Task too complex
- Infinite loop
- Waiting for unavailable resource

**Solutions:**
- Break into smaller tasks
- Set appropriate timeout
- Check for blocking operations

**Prevention:** Estimate complexity before spawning agents

---

### Context Overflow

**Error:** Context too large

**Cause:** Too much content in agent context

**Solutions:**
- Summarize before passing
- Use targeted queries
- Split into multiple agents

**Prevention:** Keep agent prompts focused

---

## API/Network Errors

### Timeout

**Error:** Request timeout

**Causes:**
- Slow network
- Overloaded server
- Large payload

**Solutions:**
- Retry with backoff
- Reduce payload size
- Check network connectivity

**Prevention:** Set reasonable timeouts, implement retry logic

---

### Rate Limited

**Error:** 429 Too Many Requests

**Cause:** Exceeded API rate limits

**Solutions:**
- Add delays between requests
- Implement exponential backoff
- Cache responses

**Prevention:** Track request rates, batch when possible

---

## Prevention Strategies Summary

| Error Type | Prevention |
|------------|------------|
| File not found | Verify paths before use |
| Permission denied | Check permissions first |
| Pattern errors | Escape special characters |
| Edit conflicts | Read immediately before edit |
| Large files | Check size, use pagination |
| Rate limits | Implement throttling |
| Timeouts | Set appropriate limits |
