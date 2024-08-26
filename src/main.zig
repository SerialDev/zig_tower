// src/main.zig
const std = @import("std");
const c = @cImport({
    @cInclude("stdio.h");
});
const r = @cImport(@cInclude("raylib.h"));

const GameScreen = enum(u32) { LOGO = 0, TITLE, GAMEPLAY, ENDING };

pub fn main() !void {
    const screenWidth: u32 = 800;
    const screenHeight: u32 = 450;
    r.InitWindow(screenWidth, screenHeight, "My Window Name");
    var framesCounter: u32 = 0;
    r.SetTargetFPS(60);
    defer r.CloseWindow();
    var currentScreen: GameScreen = GameScreen.LOGO;

    while (!r.WindowShouldClose()) {
        switch (currentScreen) {
            GameScreen.LOGO => {
                framesCounter += 1;
                if (framesCounter > 120) {
                    currentScreen = GameScreen.TITLE;
                } // Count frames

            },
            GameScreen.TITLE => {
                if (r.IsKeyPressed(r.KEY_ENTER) or r.IsGestureDetected(r.GESTURE_TAP)) {
                    currentScreen = GameScreen.GAMEPLAY;
                }
            },
            else => {},
        }
        r.BeginDrawing();
        r.ClearBackground(r.RAYWHITE);
        switch (currentScreen) {
            GameScreen.LOGO => {
                c.printf(framesCounter);
                r.DrawText("LOGO SCREEN", 20, 20, 40, r.LIGHTGRAY);
            },
            else => {},
        }
        r.EndDrawing();
    }
}

test "simple test" {}
