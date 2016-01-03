def TreeSearch(L, I, b, e):
    if e - b == 1:
        R = SearchInStrip(L, b, e)
    else:
        L_p, Q =  split(L, b, e)
        intersections, R_p = findStaircaseIntersections(Q, L_p) 
        c = (b + e) / 2
        #Divide I into I_l, and I_r 
        R_l = TreeSearch(L, I_l, b, c)
        if p_c is a left endpoint:
            L_r = R_l.insert(p_c)
        else:
            L_r = R_l.delete(p_c)
        R_r = TreeSearch(L_r, I_r, c, e)
        intersections, R_p = findStaircaseIntersections(Q, L_p)     #TODO check
        for s in I:
            find stair of s                                         #using binary search 
        Find Int(Q, I)
        R = Merge(Q, R_r)
