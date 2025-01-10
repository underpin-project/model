#define URLIFY(x)           bind(lcase(replace(replace(replace(x, "[^\\p{L}0-9]", "_"), "_+", "_"), "^_|_$", "")) as x##_URLIFY)
#define SPLIT(x)            x##_SPLIT spif:split (x ", ?").
