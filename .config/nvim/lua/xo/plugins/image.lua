return {
    "3rd/image.nvim",
    ft = { "markdown" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        backend = "kitty", -- ghostty supports kitty protocol
        processor = "magick_cli", -- requires imagemagick
        integrations = {
            markdown = {
                enabled = true,
                clear_in_insert_mode = true,
                only_render_image_at_cursor = false,
                filetypes = { "markdown" },
            },
        },
        max_width = 100,
        max_height = 50,
        max_height_window_percentage = 60,
        max_width_window_percentage = 80,
        window_overlap_clear_enabled = true,
    },
}
