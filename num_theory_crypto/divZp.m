function z = divZp(x, y, p)
    y_inv = invZp(y, p);
    z = mulZp(x, y_inv, p);
end