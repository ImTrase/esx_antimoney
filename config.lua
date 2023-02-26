cfg = {}

cfg.max = {
    ['bank'] = 5000000,
    ['money'] = 500000,
    ['black_money'] = 500000
}

cfg.whitelisted_groups = { 'admin' } -- Whitelisted group(s)
cfg.flag = 'kick' -- kick, wipe, log (Kick = Kick & Wipes players money | Wipe = Only wipe players money | Log = Only log to discord [cfg.webhook must be filled out]) [Both Kick & Wipe log if you have it filled out below]

cfg.checkTime = 15 -- Seconds
cfg.webhook = '' -- The webhook the logs are sent to