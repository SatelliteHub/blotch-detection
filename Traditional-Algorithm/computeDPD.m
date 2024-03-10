function [E_b, E_f] = computeDPD(prevFrame, currFrame, nextFrame, fdx, fdy, bdx, bdy, imgH, imgW)
    I_prev = prevFrame(:,:,1);
    I_curr = currFrame(:,:,1);
    I_next = nextFrame(:,:,1);

    X = ones(imgH, 1) .* (1:imgW);
    Y = (1:imgH)' .* ones(1, imgW);

    mc_b = interp2(X, Y, I_prev, X+bdx, Y+bdy);
    mc_f = interp2(X, Y, I_next, X+fdx, Y+fdy);
    
    mc_b(isnan(mc_b)) = 0;
    mc_f(isnan(mc_f)) = 0;

    E_b = I_curr - mc_b;
    E_f = I_curr - mc_f;
end