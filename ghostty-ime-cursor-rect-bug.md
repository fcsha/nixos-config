# Ghostty IME 候选词面板向上展开时遮挡 preedit 的问题

## 问题描述

在 Wayland（niri 合成器）下使用 fcitx5 输入法时，Ghostty 终端中：

- 候选词面板**向下展开**时正常（面板在拼音下方，不遮挡）
- 候选词面板**向上展开**时（光标接近窗口底部），面板的 bottom 锚到了拼音所在行的**底部**，导致面板覆盖了输入框中的 preedit 文本（拼音）

对照实验确认问题出在 Ghostty：Zed 编辑器及其内置终端无此问题，仅 Ghostty（及在其中运行的 TUI 程序如 opencode）有此问题。

## 环境

| 组件 | 版本 |
|------|------|
| Ghostty | 1.3.1 |
| fcitx5 | 5.1.19 |
| niri | 26.04 |
| GTK | 4.22.4（Ghostty app runtime） |
| 前端协议 | Wayland text-input-v3 + input-method-v2（`waylandFrontend = true`） |

## Bug 位置

**文件**：`src/apprt/gtk/class/surface.zig`
**行号**：1233-1238

```zig
if (priv.core_surface) |surface| {
    const ime_point = surface.imePoint();
    priv.im_context.as(gtk.IMContext).setCursorLocation(&.{
        .f_x = @intFromFloat(ime_point.x),
        .f_y = @intFromFloat(ime_point.y),
        .f_width = 1,
        .f_height = 1,
    });
}
```

## 根因（两个问题）

### 问题 1（直接导致向上展开遮挡）：`f_y` 传的是行底部

`imePoint()` 定义在 `src/Surface.zig:2068-2138`，其中 y 的计算（2093-2104 行）：

```zig
const y: f64 = y: {
    // Simple y * cell height gives the top-left corner, then add padding offset
    var y: f64 = @floatFromInt(cursor.y * self.size.cell.height + self.size.padding.top);

    // We want the bottom
    y += @floatFromInt(self.size.cell.height);

    // And scale it
    y /= content_scale.y;

    break :y y;
};
```

注释 `// We want the bottom` 明确说明 y 取的是光标行的**底部**。

但 `GdkRectangle.y` 按 GTK / Wayland 约定是矩形的**左上角（顶部）**。GTK4 的 Wayland IM context 实现确认了这一点——`gtk_im_context_wayland_set_cursor_location`（`gtkimcontextwayland.c:1183-1218`）仅对 x/y 做 widget→surface 的坐标平移，width/height 原样保留，最终直接传给 `zwp_text_input_v3_set_cursor_rectangle`：

```c
// gtkimcontextwayland.c:438-448
rect = context->cursor_rect;
zwp_text_input_v3_set_cursor_rectangle(global->text_input,
    rect.x, rect.y, rect.width, rect.height);
```

因此传出去的 cursor rectangle 的 y 实际是行底部，而非行顶部。

### 问题 2：`f_height` 硬编码为 1px

`f_height = 1` 使 cursor rectangle 退化为一个 1×1 的点。

而 `imePoint()` 已经计算了正确的行高（`Surface.zig:2108-2112`）：

```zig
// Our height for now is always just the cell height because our preedit
// rendering only renders in a single line.
const height: f64 = height: {
    var height: f64 = @floatFromInt(self.size.cell.height);
    height /= content_scale.y;
    break :height height;
};
```

返回结构体（`Surface.zig:2132-2137`）包含了正确的 `.height` 字段，但 GTK surface 调用 `setCursorLocation` 时没有使用它。

## 为什么向下展开正常、向上展开遮挡

实际传给 Wayland 协议的 cursor rectangle 为 `{x, 行底部, 1, 1}` —— 位于光标行底部的一个 1×1 点。

合成器（niri）依据 cursor rectangle 定位 input popup：

| 展开方向 | 合成器锚点计算 | 结果 |
|---------|--------------|------|
| 向下 | `popup.top = cursor_rect.bottom` ≈ 行底部 | popup 从行底部向下展开，preedit 在行内不被遮挡 |
| 向上 | `popup.bottom = cursor_rect.top` = **行底部** | popup 从行底部向上展开，覆盖整个 preedit 行 |

向下展开碰巧正常是因为 cursor rectangle 恰好在行底（popup 往下不碰 preedit）；向上展开必然遮挡（popup 从行底往上盖）。

## 证据链（均有源码支撑，非推测）

1. **Ghostty 源码**（v1.3.1）
   - `src/apprt/gtk/class/surface.zig:1236-1237`：写死 `.f_width = 1, .f_height = 1`
   - `src/Surface.zig:2097`：注释 `// We want the bottom`，y 取行底部
   - `src/Surface.zig:2108-2112`：已计算正确的 `height`（cell_height）但未被调用处使用

2. **GTK4 源码**
   - `gtkimcontextwayland.c:1198`：`rect = *cursor_rect` 原样复制
   - `gtkimcontextwayland.c:1207-1208`：仅对 x/y 做坐标平移，width/height 不变
   - `gtkimcontextwayland.c:447-448`：原样传给 `zwp_text_input_v3_set_cursor_rectangle`

3. **用户对照实验**：Zed（正确传行高 rectangle）无此问题，Ghostty 有，锁定 Ghostty

4. **现象自洽**：向下展开碰巧正常、向上展开必遮挡，与 cursor rectangle 位于行底的推导完全吻合

## 修复方向

`imePoint()` 已返回正确的 `.height`（cell_height），修复只需在 `setCursorLocation` 调用处使用它，并把 y 从行底部改为行顶部：

```zig
priv.im_context.as(gtk.IMContext).setCursorLocation(&.{
    .f_x = @intFromFloat(ime_point.x),
    .f_y = @intFromFloat(ime_point.y - ime_point.height),
    .f_width = 1,
    .f_height = @intFromFloat(ime_point.height),
});
```

修复后 cursor rectangle 为 `{x, 行顶部, 1, cell_height}`：

- 向下展开：`popup.top = cursor_rect.bottom` = 行底部 → popup 在 preedit 下方
- 向上展开：`popup.bottom = cursor_rect.top` = 行顶部 → popup 在 preedit 上方
