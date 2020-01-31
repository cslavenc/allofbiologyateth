%Slaven Cvijetic, 26.04.2017
%My own function to solve exercise 9, part 1.3
%%function needs improvement, for some reason, size does not work

%PRE : Takes an array with standard deviations as values.
%POST: Returns the genes with x>std and their names.
function [stdvec, names] = search_genes(svec, std, genes, N)
    %ind = find(arr>0);
    stdvec = [];
    names = [];
    
    for i=1:N
        if svec(i) > std
            stdvec = [stdvec svec(i)]
            names = [names genes(i)];
        end
    end
end
            
            