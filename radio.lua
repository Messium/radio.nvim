local M = {}
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

M.radio = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Select radio",
    finder = finders.new_table({
        results = {
                { "Cadena SER", "http://27833.live.streamtheworld.com/CADENASER.mp3" },
                { "IB3", "http://streaming01.ib3radio.com:8000/ib3radio.mp3" },
                { "RNE", "https://rtvelivestream.akamaized.net/rtvesec/rne/rne_r1_main.m3u8?idasset=1712486" },
                { "RNE - Música Clásica", "https://rtvelivestream.akamaized.net/rtvesec/rne/rne_r2_main.m3u8?idasset=1712494" },
                { "Latina Reggaeton", "http://latinareggaeton.ice.infomaniak.ch/latinareggaeton.mp3" },
                { "100% Reggaeton", "https://stream-148.zeno.fm/qmhf2yd9dm0uv" },
                { "Lofi HipHop", "http://hyades.shoutca.st:8043/stream" },
                { "Ràdio Nacional d'Andorra", "https://play.cdn.enetres.net/56495F77FD124FECA75590A906965F2C023/023/playlist.m3u8" },
                { "Andorra Música", "https://play.cdn.enetres.net/56495F77FD124FECA75590A906965F2C024/024/playlist.m3u8" },
                { "RAC1", "https://playerservices.streamtheworld.com/api/livestream-redirect/RAC_1.mp3" },
                { "Catalunya Ràdio", "https://directes-radio-int.ccma.cat/live-content/catalunya-radio-hls/master.m3u8" },
                { "Catalunya Informació", "https://shoutcast.ccma.cat/ccma/catalunyainformacioHD.mp3" },
                { "Liquid DnB", "http://95.47.244.172:8000/live" },
                { "DnB FM", "https://air.dnbfm.ru/listen/player/qplay" },
                { "P1", "http://sverigesradio.se/topsy/direkt/132-hi-aac.pls" },
                { "P2", "https://http-live.sr.se/p2musik-aac-320" },
                { "P3", "https://sverigesradio.se/topsy/direkt/164-hi-mp3.m3u" },
                { "Cumbias Inmortales Radio (Monterrey)", "https://panel.retrolandigital.com/listen/cumbias_inmortales_radio/listen"},
        },
        entry_maker = function(entry)
                return {
                value = entry,
                display = entry[1],
                ordinal = entry[2],
                }
        end
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            vim.cmd("!pkill -9 mpv")
            vim.print(selection.ordinal)
            -- vim.print(type(selection.ordinal))
                -- string returned
            vim.system({'mpv', selection.ordinal, '--input-ipc-server=/tmp/mpvsocket', '& disown'}, { text = true })
        end)
        return true
        end,
  }):find()
end

-- TODO:
-- pass this mpv file --input-ipc-server=/tmp/mpvsocket
-- and then this:
-- echo cycle pause | socat - "$XDG_CONFIG_HOME/mpv/socket"
M.pause = function()
    vim.system({'echo cycle pause | socat - "/tmp/mpvsocket"'}, { text = true })
end
-- -- to execute the function
-- radio()
-- TODO: create a function that shutdown when neovim shutdown.
-- TODO: Create a function that can be called manually to kill mpv.

return M
