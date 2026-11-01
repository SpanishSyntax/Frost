---
name: deep-audiobook
description: >-
  Synthesizes comprehensive, conversational lecture companions and textbook
  notes into publication-grade, chapter-indexed M4B and MP3 audiobooks using
  Skald, sentence-chunked neural TTS, and multi-voice dramatization. Use this
  skill when the user asks to create an audiobook companion, spoken lecture series,
  podcast walkthrough, or oral course guide from lecture notes, slides, or chapters.
---

# Deep Audiobook (Conversational Lecture Companion & M4B Audiobook Compiler)

## Summary
Synthesizes dense technical textbooks, reader notes, lecture slides, and mathematical syllabi into conversational, broadcast-grade oral companions and chapter-indexed M4B audiobooks. Engineered for deep auditory comprehension: instead of reading literal formula algebra or ungrounded Greek symbols, it translates abstract mathematics into intuitive physical mechanics, engineering bottlenecks, and conversational dialogues. Powered by **Skald**, sentence-chunked Microsoft Edge-TTS neural speech, multi-voice speaker parsing, and FFmpeg MPEG-4 chapter muxing.

## When to Use
- The user requests an audiobook companion, audio lecture, podcast breakdown, or spoken companion for a course, book, or technical subject.
- The user asks to turn a written reader (`AI/reader/`) or markdown summary into audio files (`.m4b` / `.mp3`).
- The user asks to synthesize multi-chapter spoken materials with embedded QuickTime chapter marks and metadata.

## Operational Contract (🎙️ Spoken Pedagogical Standard)
- **Spoken Mechanics Over Formula Recitation**: Never recite raw algebra character-by-character (e.g., avoid *"x transpose capital H x plus c transpose x"*). Instead, speak the physical intuition: *"a bowl-shaped valley curved by the Hessian matrix, tilted down the slope of the linear gradient vector"*.
- **Sentence-Level Chunking**: Never send text blocks larger than 2,500 characters to Azure Neural TTS. Always chunk at sentence boundaries to avoid websocket drops and `NoAudioReceived` connection aborts.
- **True QuickTime / M4B Chapter Markers**: Deliver `.m4b` files with embedded `FFMETADATA1` structures for full scrub bar navigation in Apple Books, Audible, VLC, and mobile players.
- **Dual Format Deliverables**: Export both standalone chapter `.m4b` / `.mp3` files and a unified master audiobook (`Master_Course_Companion.m4b`).
- **Resilient Retry Loop**: Rely on built-in exponential backoff (up to 5 retries) and timeout watchdogs against cloud TTS rate limits.

---

## Authoring Transcripts for Speech

Transcripts reside in `AI/audio/transcripts/chXX_name.md` and support frontmatter and multi-voice annotations:

```markdown
---
title: "Quadratic Programming and KKT Conditions"
author: "Antigravity Course Companion"
album: "Optimization for Systems and Control"
voice: "en-US-GuyNeural"
speaker_narrator: "en-US-GuyNeural"
speaker_professor: "en-US-ChristopherNeural"
speaker_student: "en-US-AriaNeural"
---

# 1. Introduction: The Bowl in the Valley

Imagine placing a marble on the surface of a polished ceramic bowl.

**Professor:** The quadratic term defines the bowl's curvature, while the linear term tilts it.

**Student:** What happens when an obstacle blocks the marble?

**Professor:** That obstacle is an inequality constraint, and the KKT multiplier measures the exact contact force preventing it from sliding deeper.
```

---

## Toolchain & Compilation Pipeline

### Step 1: Voice Discovery (`skald voices`)
List and filter available neural voices:
```bash
# Discover voices for a specific locale
skald voices --locale en-US --gender Male
skald voices --locale nl-NL
```

### Step 2: Synthesize Transcripts (`skald narrate`)
Compile individual chapter transcripts into standalone `.m4b` and `.mp3` files:
```bash
# Narrate a single transcript
skald narrate transcripts/ch01_foundations.md --voice en-US-GuyNeural -o ./audio/

# Machine JSON output for agents
skald narrate transcripts/ch01_foundations.md --json
```

### Step 3: Stitch Master Course Audiobook (`skald stitch`)
Merge all standalone chapter audiobooks into a single master companion with navigable chapter marks:
```bash
skald stitch ./audio/ \
  --output ./audio/SC42056_Master_Course_Companion.m4b \
  --title "SC42056 Optimization: Spoken Course Companion" \
  --author "TU Delft Systems & Control" \
  --album "SC42056 Optimization" \
  --cover ./cover.png \
  --mp3
```

### Step 4: Inspect Audiobook Markers (`skald inspect`)
Inspect embedded chapter points, bitrates, and durations:
```bash
skald inspect ./audio/SC42056_Master_Course_Companion.m4b
```
