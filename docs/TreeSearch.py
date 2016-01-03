def TreeSearch(S, b, e):
    if (e - b) == 1:
        SearchInStrip(S)
    else:
        Q, S_p = Split(S)
        Intersections(Q, S_p)

        c = (b + e) / 2

        S_l = Crossing(S, b, c)
        S_r = Crossing(S, c, e)

        TreeSearch(S_l, b, c)
        TreeSearch(S_r, c, e)
