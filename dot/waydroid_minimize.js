workspace.windowList().forEach(w => {
    if (w.caption.includes("Waydroid")) {
        w.minimized = true;
    }
});
