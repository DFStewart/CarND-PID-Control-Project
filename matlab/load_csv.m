function out = load_csv(filename)
    M = csvread(filename);
    out.cte     = M(:,1);
    out.p_error = M(:,2);
    out.i_error = M(:,3);
    out.d_error = M(:,4);
    out.Kp      = M(:,5);
    out.Ki      = M(:,6);
    out.Kd      = M(:,7);
end