# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Test Commands

- use `pnpm` if a `pnpm-workspace.yaml` file is present. Otherwise, use `npm`
- Install: `pnpm install` or `npm install`
- Run all tests: `pnpm run test` or `npm test`
- Run single test: use the node test runner, e.g. `node --test ./test/filename.test.js`

## Code Style Guidelines

- Use Standard JS style (2-space indentation, no semicolons)
- Use single quotes for strings
- Begin files with 'use strict'
- Use CommonJS module system (require/module.exports)
- Use ES modules import only when necessary
- Use try/catch for error handling with specific error messages
- Follow Node.js error pattern (checking err.code)
- Avoid using maps in favour of `for`.
- Use the Promise version of `setTimeout`, e.g. `await setTimeout(1000)` to wait one second.
- Avoid using `promisify`, look for alternatives which are alredy promises.
- If a variable is unused but must be specified, name it `_` and add an `/* eslint-disable-next-line no-unused-vars */` comment before the line.
- Don't write too much comments in tests is not necessary to explain every trivial assert.

## Type System

- Strong typing for request/response objects
- Interface-based approach for API endpoints

## Runtime Requirements

- Node.js version: 22.x or 24.x

## Save Point Commands

When you use these commands, I'll manage git stashes for you as code save points:

- `create save NAME` - Create a save point with the name provided
- `list saves` - Show all available save points
- `return to save NAME` - Restore code to the specified save point
- `remove save NAME` - Delete a save point when no longer needed

## Memory Management

- Always use user-level memory (~/.claude/CLAUDE.md) instead of project-specific memory
- Don't add .claude folder to any project
- Use the user's global memory file for all persistent information
