#!/usr/bin/env python3
import time

import pyautogui


def switch_tabs():
    pyautogui.hotkey("ctrl", "tab")


def switch_windows():
    pyautogui.hotkey("alt", "tab")


def next_page():
    pyautogui.hotkey("alt", "f")


def previous_page():
    pyautogui.hotkey("alt", "u")


# Set the interval in seconds
interval = 3 * 5

try:
    while True:
        time.sleep(interval)
        # 30 seconds use the next page then previous page
        for _ in range(6):
            next_page()
            time.sleep(8)
        for _ in range(6):
            previous_page()
            time.sleep(8)
except KeyboardInterrupt:
    print("Script terminated by user.")
