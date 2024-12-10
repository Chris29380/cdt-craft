Options = {}

Options.zonescraft = {
    [1] = 
        {
            -- blip
            showblip = true,
            type = 1,
            color = 1,
            scale = 1.0,
            label = "Craft",
            -- coords
            coords = vector3(10.048, -376.813, 38.709),
            -- marker
            markertype = 28,
            markercolor = {R = 255, G = 122, B = 0, A = 255},
            scalex = 0.05,
            scaley = 0.05,
            scalez = 0.05,
            -- action
            labelaction = "Craft",
            keyaction = "E",
            keycode = 38,
            -- recipes
            recipes = {
                {itemfinal = "burger", qtyfinal = 2, labelitemfinal ="Burger",
                    items = {
                        {name = "sprunk", qty = 1, labelitem = "Sprunk"},
                        {name = "mustard", qty = 1, labelitem = "Mustard"},
                    },
                    anim = {dict = "amb@world_human_bum_standing@twitchy@idle_a", animation = "idle_c"},
                    scenario = "",
                    timer = 10000,
                },
                {itemfinal = "burger", qtyfinal = 2, labelitemfinal ="Burger",
                    items = {
                        {name = "sprunk", qty = 1, labelitem = "Sprunk"},
                        {name = "mustard", qty = 1, labelitem = "Mustard"},
                    },
                    anim = {dict = "amb@world_human_bum_standing@twitchy@idle_a", animation = "idle_c"},
                    scenario = "",
                    timer = 10000,
                },
            },
            -- distances
            drawdistance = 5.0,
            actiondistance = 1.5,
            -- stash
            stash = {
                slots = 20,
                maxweight = 100000,
                owner = true,
                groups = {},
            },
        },
}