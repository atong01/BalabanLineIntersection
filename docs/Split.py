def split(L, b, e):
    L_p = []
    Q   = []                    #Ordered from lowest to highest
    for j in range(1, k):
        if intersection(L[j], Q[-1]) == False and spans(L[j], b, e):
            Q.append(L[j])
        else:
            L_p.append(L[j])
    return L_p, Q
