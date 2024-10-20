#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <Richedit.h>  // Include for RichEdit control
#include <gdiplus.h>   // Include for GDI+ to handle images

// Global variables
HWND hCpsInput, hStartButton, hStopButton, hHotkeyButton, hHotkeyDisplay, hOutputTerminal, hBackgroundButton;
int running = 0;
int cps = 10; // Default CPS
int hotkey = 0; // Hotkey code
int isSelectingHotkey = 0; // Flag for hotkey selection
HANDLE hThread = NULL; // Thread for auto-clicking
HBRUSH hbrBkgnd = NULL; // Brush for background color/image
Gdiplus::Image *backgroundImage = NULL; // For GDI+ background image

// Auto clicker function
DWORD WINAPI AutoClicker(LPVOID lpParam) {
    while (running) {
        // Simulate mouse click
        mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
        mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
        // Sleep based on CPS
        Sleep(1000 / cps);
    }
    return 0;
}

// Function to update the start button (animations or text change)
void ToggleStartButton(int isRunning) {
    if (isRunning) {
        SetWindowText(hStartButton, "Loading...");
    } else {
        SetWindowText(hStartButton, "Start");
    }
}

// Function to set background image (with GDI+)
void SetBackgroundImage(const wchar_t* imagePath, HWND hwnd) {
    // Clean up existing background image
    if (backgroundImage) {
        delete backgroundImage;
        backgroundImage = NULL;
    }

    backgroundImage = Gdiplus::Image::FromFile(imagePath);
    InvalidateRect(hwnd, NULL, TRUE); // Redraw window with new background
}

// Function to paint background image
void PaintBackground(HWND hwnd, HDC hdc) {
    if (backgroundImage) {
        Gdiplus::Graphics graphics(hdc);
        Gdiplus::Rect rect(0, 0, 300, 200); // Adjust as needed
        graphics.DrawImage(backgroundImage, rect);
    }
}

// Window procedure
LRESULT CALLBACK WindowProcedure(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp) {
    char buffer[10];
    PAINTSTRUCT ps;
    HDC hdc;

    switch (msg) {
    case WM_COMMAND:
        if (LOWORD(wp) == 1) { // Start button clicked
            if (!running) {
                running = 1;
                GetWindowText(hCpsInput, buffer, 10);
                cps = atoi(buffer);
                if (cps < 1) cps = 1; // Minimum CPS is 1
                hThread = CreateThread(NULL, 0, AutoClicker, NULL, 0, NULL);
                ToggleStartButton(1);
            }
        } else if (LOWORD(wp) == 2) { // Stop button clicked
            if (running) {
                running = 0;
                if (hThread) {
                    WaitForSingleObject(hThread, INFINITE);
                    CloseHandle(hThread);
                    hThread = NULL;
                }
                ToggleStartButton(0);
            }
        } else if (LOWORD(wp) == 3) { // Hotkey button clicked
            isSelectingHotkey = 1;
            SetWindowText(hHotkeyDisplay, "Press any key...");
        } else if (LOWORD(wp) == 4) { // Change background button clicked
            // Set an example image (you can change this path)
            SetBackgroundImage(L"path_to_your_image.jpg", hwnd);
        }
        break;

    case WM_KEYDOWN:
        if (isSelectingHotkey) {
            hotkey = (int)wp; // Capture hotkey
            char hotkeyText[20];
            sprintf(hotkeyText, "Hotkey: %d", hotkey);
            SetWindowText(hHotkeyDisplay, hotkeyText);
            isSelectingHotkey = 0;
        } else if ((int)wp == hotkey) {
            if (!running) {
                SendMessage(hwnd, WM_COMMAND, 1, 0);
            } else {
                SendMessage(hwnd, WM_COMMAND, 2, 0);
            }
        }
        break;

    case WM_PAINT:
        hdc = BeginPaint(hwnd, &ps);
        PaintBackground(hwnd, hdc); // Paint background image if set
        EndPaint(hwnd, &ps);
        break;

    case WM_DESTROY:
        running = 0;
        if (hThread) {
            WaitForSingleObject(hThread, INFINITE);
            CloseHandle(hThread);
        }
        PostQuitMessage(0);
        break;

    default:
        return DefWindowProc(hwnd, msg, wp, lp);
    }
    return 0;
}

// GUI creation function
void CreateGUI(HINSTANCE hInst, HWND hwnd) {
    CreateWindow("STATIC", "CPS:", WS_VISIBLE | WS_CHILD, 20, 20, 50, 20, hwnd, NULL, hInst, NULL);
    hCpsInput = CreateWindow("EDIT", "10", WS_VISIBLE | WS_CHILD | WS_BORDER, 80, 20, 50, 20, hwnd, NULL, hInst, NULL);
    hStartButton = CreateWindow("BUTTON", "Start", WS_VISIBLE | WS_CHILD, 150, 20, 100, 30, hwnd, (HMENU)1, hInst, NULL);
    hStopButton = CreateWindow("BUTTON", "Stop", WS_VISIBLE | WS_CHILD, 150, 60, 100, 30, hwnd, (HMENU)2, hInst, NULL);
    hHotkeyButton = CreateWindow("BUTTON", "Set Hotkey", WS_VISIBLE | WS_CHILD, 150, 100, 100, 30, hwnd, (HMENU)3, hInst, NULL);
    hHotkeyDisplay = CreateWindow("STATIC", "Hotkey: None", WS_VISIBLE | WS_CHILD, 20, 100, 120, 20, hwnd, NULL, hInst, NULL);
    
    // Terminal output area (using RichEdit control)
    hOutputTerminal = CreateWindow("RICHEDIT50W", "", WS_VISIBLE | WS_CHILD | ES_MULTILINE | WS_VSCROLL | ES_AUTOVSCROLL, 20, 150, 250, 100, hwnd, NULL, hInst, NULL);

    // Background image change button
    hBackgroundButton = CreateWindow("BUTTON", "Change Background", WS_VISIBLE | WS_CHILD, 150, 260, 130, 30, hwnd, (HMENU)4, hInst, NULL);
}

// Main function
int WINAPI WinMain(HINSTANCE hInst, HINSTANCE hPrevInst, LPSTR args, int ncmdshow) {
    WNDCLASS wc = {0};
    Gdiplus::GdiplusStartupInput gdiplusStartupInput;
    ULONG_PTR gdiplusToken;
    
    // Initialize GDI+
    Gdiplus::GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);
    
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hInstance = hInst;
    wc.lpszClassName = "AutoClicker";
    wc.lpfnWndProc = WindowProcedure;

    if (!RegisterClass(&wc)) return -1;

    HWND hwnd = CreateWindow("AutoClicker", "Auto Clicker with Hotkey", WS_OVERLAPPEDWINDOW | WS_VISIBLE, 200, 200, 300, 320, NULL, NULL, hInst, NULL);
    CreateGUI(hInst, hwnd);

    MSG msg = {0};
    while (GetMessage(&msg, NULL, NULL, NULL)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    // Shutdown GDI+
    Gdiplus::GdiplusShutdown(gdiplusToken);
    return 0;
}
