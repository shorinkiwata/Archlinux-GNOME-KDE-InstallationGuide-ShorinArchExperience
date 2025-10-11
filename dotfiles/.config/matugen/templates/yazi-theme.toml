# : Manager [[[

[manager]
cwd = { fg = "{{colors.on_surface.default.hex}}" }

# Tab
tab_active = { fg = "{{colors.on_primary.default.hex}}", bg = "{{colors.primary.default.hex}}", bold = true }
tab_inactive = { fg = "{{colors.primary_fixed.default.hex}}", bg = "{{colors.on_primary_fixed.default.hex}}" }
tab_width = 1

# Find
find_keyword = { fg = "{{colors.error.default.hex}}", bold = true, italic = true, underline = true }
find_position = { fg = "{{colors.error.default.hex}}", bold = true, italic = true }

# Marker
marker_copied = { fg = "{{colors.tertiary_fixed.default.hex | auto_lightness: 20.0}}", bg = "{{colors.tertiary_fixed.default.hex | auto_lightness: 20.0}}" }
marker_cut = { fg = "{{colors.tertiary_fixed.default.hex}}", bg = "{{colors.tertiary_fixed.default.hex}}" }
marker_marked = { fg = "{{colors.error.default.hex}}", bg = "{{colors.error.default.hex}}" }
marker_selected = { fg = "{{colors.tertiary.default.hex}}", bg = "{{colors.tertiary.default.hex}}" }

# Count
count_copied = { fg = "{{colors.on_tertiary_fixed.default.hex}}", bg = "{{colors.tertiary_fixed.default.hex}}" }
count_cut = { fg = "{{colors.on_tertiary_fixed.default.hex}}", bg = "{{colors.tertiary_fixed.default.hex}}" }
count_selected = { fg = "{{colors.on_primary.default.hex}}", bg = "{{colors.tertiary.default.hex}}" }

# Border
border_symbol = "│"
border_style  = { fg = "{{colors.surface_tint.default.hex}}" }

# : ]]]


# : Status [[[

[status]
separator_open = "🭁"
separator_close = "🭠"
separator_style = { bg = "{{colors.on_primary.default.hex}}", fg = "#F4A261" }

[mode]
# Mode
normal_main = { bg = "{{colors.primary.default.hex}}", fg = "{{colors.on_primary.default.hex}}", bold = true }
normal_alt  = { bg = "{{colors.surface_variant.default.hex}}", fg = "{{colors.on_surface_variant.default.hex}}" }

# Select mode
select_main = { bg = "{{colors.secondary.default.hex}}", fg = "{{colors.on_secondary.default.hex}}", bold = true }
select_alt  = { bg = "{{colors.surface_variant.default.hex}}", fg = "{{colors.on_surface_variant.default.hex}}" }

# Unset mode
unset_main = { bg = "{{colors.tertiary.default.hex}}", fg = "{{colors.on_tertiary.default.hex}}", bold = true }
unset_alt  = { bg = "{{colors.surface_variant.default.hex}}", fg = "{{colors.on_surface_variant.default.hex}}" }

# Progress
progress_label = { bold = true }
progress_normal = { fg = "{{colors.primary.default.hex}}", bg = "{{colors.surface_bright.default.hex}}" }
progress_error = { fg = "{{colors.error.default.hex}}", bg = "{{colors.surface_bright.default.hex}}" }

# Permissions
permissions_t = { fg = "{{colors.secondary.default.hex | auto_lightness: 30.0}}" }
permissions_w = { fg = "{{colors.tertiary.default.hex | auto_lightness: 30.0}}" }
permissions_x = { fg = "{{colors.error.default.hex | auto_lightness: 30.0}}" }
permissions_r = { fg = "{{colors.tertiary_fixed.default.hex | auto_lightness: 30.0}}" }
permissions_s = { fg = "{{colors.primary_fixed.default.hex | auto_lightness: 30.0}}" }

# : ]]]


# : Select [[[

[select]
border = { fg = "{{colors.primary.default.hex}}" }
active = { fg = "{{colors.tertiary.default.hex}}", bold = true }
inactive = {}

# : ]]]


# : Input [[[

[input]
border = { fg = "{{colors.primary.default.hex}}" }
value = { fg = "{{colors.on_surface.default.hex}}" }

# : ]]]


# : Completion [[[

[completion]
border = { fg = "{{colors.primary.default.hex}}", bg = "{{colors.on_primary.default.hex}}" }

# : ]]]


# : Tasks [[[

[tasks]
border = { fg = "{{colors.primary.default.hex}}" }
title = {}
hovered = { fg = "{{colors.tertiary_fixed.default.hex}}", underline = true }

# : ]]]


# : Which [[[

[which]
cols = 3
mask = { bg = "{{colors.surface_bright.default.hex}}" }
cand = { fg = "{{colors.primary.default.hex}}" }
rest = { fg = "{{colors.on_primary.default.hex}}" }
desc = { fg = "{{colors.on_surface.default.hex}}" }
separator = " ▶ "
separator_style = { fg = "{{colors.on_surface.default.hex}}" }

# : ]]]


# : Help [[[

[help]
on = { fg = "{{colors.on_surface.default.hex}}" }
run = { fg = "{{colors.on_surface.default.hex}}" }
footer = { fg = "{{colors.on_secondary.default.hex}}", bg = "{{colors.secondary.default.hex}}" }

# : ]]]


# : Notify [[[

[notify]
title_info = { fg = "{{colors.tertiary.default.hex}}" }
title_warn = { fg = "{{colors.primary.default.hex}}" }
title_error = { fg = "{{colors.error.default.hex}}" }

# : ]]]


# : File-specific styles [[[

[filetype]

rules = [
    # Images
    { mime = "image/*", fg = "#94e2d5" },

    # Media
    { mime = "{audio,video}/*", fg = "#f9e2af" },

    # Archives
    { mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", fg = "#f5c2e7" },

    # Documents
    { mime = "application/{pdf,doc,rtf}", fg = "#a6e3a1" },

    # Special files
    { name = "*", is = "orphan", bg = "{{colors.error_container.default.hex}}" },
    { name = "*", is = "exec", fg = "{{colors.on_error_container.default.hex}}" },

    # Fallback
    { name = "*", fg = "{{colors.on_surface.default.hex}}" },
    { name = "*/", fg = "{{colors.surface_tint.default.hex}}" },
]

# : ]]]