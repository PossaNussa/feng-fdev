# Better Fences (1F616EMO Reimplementation)

This mod allows fences to connect to any surfaces. This can be opted in or out by right-clicking fence nodes.

Unlike the [original implementation by ChimneySwift](https://content.luanti.org/packages/ChimneySwift/better_fences/), this mod supports all fences and walls without any hacks. Mods need not to detect the existance of this mod before registering toggleable fences, though the function `better_fences.register_fence` is kept to prevent breaking things.

This mod maintains gameplay-level compactibility, i.e. this mod is a drop-in replacement of the original implementation for most settings. However, API-level compactibility is not guarenteed.
