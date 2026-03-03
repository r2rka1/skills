# Research: Terminal Voice Input & iTerm2 Dictation Support

Created: 2026-03-02
Last updated: 2026-03-02
Status: done

## Summary

Most terminal emulators (iTerm2, Kitty, WezTerm) do not support macOS native dictation due to their non-standard text input handling. The only terminal with built-in voice input is **Warp**, powered by Wispr Flow. For other terminals, third-party tools like **Wispr Flow**, **Serenade**, **speech2type**, and **voice_typing** can bridge the gap by injecting transcribed text at the cursor position system-wide.

## Findings

### iTerm2 Does Not Support macOS Dictation (Open Issue)

- **Source**: https://gitlab.com/gnachman/iterm2/-/issues/5715
- **Details**: iTerm2 cannot accept macOS dictation input. The dictation popup either doesn't appear or produces no text. Apple's native Terminal.app works fine because it uses standard NSTextView input handling, but iTerm2 uses custom input methods that bypass the dictation pipeline.
- **Relevance**: This is a known, unresolved limitation. No native fix exists or is planned.

### Kitty Terminal Has the Same Limitation

- **Source**: https://github.com/kovidgoyal/kitty/issues/3732
- **Details**: Kitty also cannot receive macOS dictation input. The dictation popup fails to appear, playing a failure beep instead. The maintainer has acknowledged the issue but it appears to be an inherent limitation of how GPU-accelerated terminals handle text input on macOS.
- **Relevance**: Confirms this is a systemic issue across non-Apple terminals, not iTerm2-specific.

### WezTerm Also Lacks Dictation Support

- **Source**: https://github.com/wezterm/wezterm/issues/5180
- **Details**: WezTerm has an open feature request for macOS speech recognition/dictation support, confirming the same limitation exists there.
- **Relevance**: Further confirms this is a cross-terminal issue on macOS.

### Warp Terminal Has Built-in Voice Input

- **Source**: https://docs.warp.dev/features/warp-ai/voice
- **Details**: Warp is the only terminal with native voice input. It uses Wispr Flow for transcription and works across all input interfaces (command input, find dialog, agent mode). Voice can be activated via a configurable hotkey in Settings > AI > Voice. Voice data is processed in real-time and not retained after transcription.
- **Relevance**: If native voice-in-terminal is a must-have, Warp is currently the only option. It's available on macOS and Linux.

### Wispr Flow — System-Wide Voice Dictation for Developers

- **Source**: https://wisprflow.ai
- **Details**: Wispr Flow is a standalone macOS app that provides voice-to-text in any application, including terminals. It understands developer jargon, auto-corrects, and claims 4x typing speed. It works by intercepting at the OS level, not at the app level, so it bypasses the terminal dictation limitation. Paid product.
- **Relevance**: Best drop-in solution for adding voice input to iTerm2 or any terminal without switching terminals. Works at OS level so terminal compatibility is not an issue.

### Serenade — Voice Coding with Terminal Support

- **Source**: https://serenade.ai
- **Details**: Open-source voice coding assistant trained on programming languages. Supports custom voice commands (e.g., "build" → focuses terminal, types `yarn build`, presses enter). Integrates with VS Code, JetBrains, and terminal environments. Speech-to-code engine understands function names, variable references, and structural commands.
- **Relevance**: Good for voice-driven coding workflows. Less suited for general terminal dictation, more for structured voice commands mapped to actions.

### speech2type — Lightweight macOS CLI Voice Typing

- **Source**: https://github.com/gergomiklos/speech2type
- **Details**: npm-installable CLI tool (`npm install -g speech2type`). Uses Deepgram API for transcription. Injects text at cursor position via accessibility APIs (not clipboard). Triggered by a global hotkey (default: ⌘;). Supports 40+ languages. Requires macOS 13+ with Apple Silicon, Node.js 18+, and a free Deepgram API key.
- **Relevance**: Lightweight, works in any app including terminals. Cloud-based transcription (Deepgram).

### voice_typing — Offline Voice Typing for Linux Terminals

- **Source**: https://github.com/themanyone/voice_typing
- **Details**: Bash script (~50 lines) using OpenAI Whisper or Whisper.cpp for offline speech recognition. Uses ydotool to type recognized text into any focused application including terminals. Requires ffmpeg, sox, lame, jq, and ydotool. Works in both X11 and Wayland sessions.
- **Relevance**: Best option for Linux users who want offline, privacy-focused voice typing in terminals. Simple and hackable.

### macOS Voice Control Has Terminal Limitations

- **Source**: https://support.apple.com/guide/mac-help/use-voice-control-commands-mh40719/mac
- **Details**: macOS Voice Control can dictate text in some apps, but has conflicts with standard dictation (you can't use both). In terminals, you need to switch between "Command Mode" (voice commands) and "Dictation Mode" (text input). Voice Control works at the accessibility level so it may work in some terminals where standard dictation doesn't, but results are inconsistent.
- **Relevance**: Partial workaround but unreliable for terminal use.

### hear — macOS CLI Speech Recognition

- **Source**: https://github.com/sveinbjornt/hear
- **Details**: Command-line interface for macOS's built-in speech recognition. Can transcribe audio from microphone or files. Output can be piped to other commands. Does not inject text into apps — outputs to stdout only.
- **Relevance**: Useful for scripting voice-to-text pipelines but requires manual integration to feed text into a terminal input.

## Open Questions

- Will iTerm2 ever implement native dictation support, or is it architecturally blocked?
- Does Wispr Flow work well with tmux/screen sessions inside terminals?
- How does Warp's voice input handle complex terminal applications (vim, htop)?

## Conclusions

1. **If you want voice input in a terminal today, the best options are:**
   - **Switch to Warp** — only terminal with native built-in voice input
   - **Use Wispr Flow** — works system-wide in any terminal (macOS, paid)
   - **Use speech2type** — lightweight, works in any terminal (macOS, free Deepgram tier)
   - **Use voice_typing** — offline option for Linux with Whisper

2. **iTerm2, Kitty, and WezTerm all lack native dictation support** due to how they handle text input. This is unlikely to change soon as it's an architectural limitation.

3. **The workaround pattern is the same**: use an external tool that captures audio, transcribes it, and injects the text at the OS/accessibility level, bypassing the terminal's input handling entirely.

4. **For the best developer experience**: Wispr Flow + iTerm2 is the most seamless combination if you want to keep using iTerm2. It understands dev terminology and works without switching terminals.
