#!/bin/sh

echo "Searching for anonymous functions"
git diff --cached | ack ^\\+.*\\bfunction\\s*\\\(
echo "Searching for logging"
git diff --cached | ack ^\\+\\s*\(console\\.log\|logger\)
echo "Searching for debugger"
git diff --cached | ack ^\\+.*\\bdebugger\\\(
