def SearchInStrip(L, b, e):
    L_p, Q = split(L, b, e)
    if L_p == []:
        R = Q
        return R
    intersections, R_p = findStaircaseIntersections(Q, L_p) 
    SearchInStrip(L_p, R_p)
    R = Merge(Q, R_p) 
