# SplitLongMessages
Splits outgoing messages longer than 2000 characters into multiple messages.

## Notes
- Prefers splitting on blank lines, then newlines, then spaces
- Includes a `Leading Blank Line Mode` setting for split chunks (`Trim`, `Invisible guard`, `Visible marker`)
- Attachments and stickers are only sent with the first chunk
- Large pastes that Discord converts to an auto `message.txt` upload are restored back into the composer when possible so the text remains editable
- Composer formatting can be slightly different from the final sent output in some long-paste cases (for example blank lines), but sent chunks preserve spacing correctly
