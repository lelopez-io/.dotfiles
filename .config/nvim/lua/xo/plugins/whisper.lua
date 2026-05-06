-- Local speech-to-text using whisper.cpp
-- <leader>I enters dictation mode, <Esc> exits and inserts transcription
-- Models download to ~/.local/share/nvim/whisper/models/

return {
    "Avi-D-coder/whisper.nvim",
    cmd = { "WhisperToggle", "WhisperDownloadModel" },
    keys = {
        {
            "<leader>I",
            function()
                -- Load plugin if needed
                require("whisper")

                local augroup = vim.api.nvim_create_augroup("WhisperDictation", { clear = true })

                -- Stop recording when leaving insert mode
                vim.api.nvim_create_autocmd("InsertLeave", {
                    group = augroup,
                    once = true,
                    callback = function()
                        vim.cmd("WhisperToggle")
                        vim.notify("Dictation stopped", vim.log.levels.INFO)
                    end,
                })

                -- Start recording
                vim.cmd("WhisperToggle")

                -- Enter insert mode
                vim.cmd("startinsert")
                vim.notify("Dictation started - speak now", vim.log.levels.INFO)
            end,
            mode = "n",
            desc = "Start dictation mode",
        },
    },
    config = function()
        require("whisper").setup({
            -- Model: base.en is a good balance of speed/accuracy (~148MB)
            model = "base.en",
            auto_download_model = true,

            -- Disable default keybinds (we use custom dictation mode)
            -- Use <Plug> mappings to avoid conflicts
            keybind = "<Plug>(whisper-toggle)",
            manual_trigger_key = "<Plug>(whisper-insert)",
            modes = {},

            -- Real-time profile for interactive dictation
            step_ms = 3000,
            length_ms = 5000,
            threads = 8,

            -- Voice detection
            vad_thold = 0.6,
            language = "en",

            -- Clean output
            filter_markers = true,
            notifications = true,
        })
    end,
}
