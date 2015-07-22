function [XijkDiag, kcps] = optim_getDiagonals(Xijk_matrix, kcpsIn)

    % return diagonal of Xijk matrix
    kcpsIn = squeeze(kcpsIn);  
    for i = 1 : size(Xijk_matrix,1)
        for j = 1 : size(Xijk_matrix,2)
            if i == j
                XijkDiag(i) = Xijk_matrix(i,j); % relative in relation to that channel
                kcps(i) = kcpsIn(i,j); % absolute units, kcps
            end
        end
    end